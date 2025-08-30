import UIKit

class ShortsCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let viewCountLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Video Storage
    private var currentVideo: Video?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
        // Update gradient frame after bounds change to prevent glitches
        updateGradient()
        
        // Apply background color after layout to ensure proper display
        if let video = currentVideo {
            thumbnailImageView.backgroundColor = ColorHelper.shortsBackgroundColor(for: video.id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear any cached data to prevent glitches
        currentVideo = nil
        titleLabel.text = nil
        viewCountLabel.text = nil
        thumbnailImageView.backgroundColor = .systemGray5
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.layer.cornerRadius = LayoutConstants.ShortsCell.cornerRadius
        contentView.clipsToBounds = true
        
        setupThumbnail()
        setupGradient()
        setupLabels()
    }
    
    private func setupThumbnail() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        // Set default background color to prevent white flash
        thumbnailImageView.backgroundColor = .systemGray5
        contentView.addSubview(thumbnailImageView)
    }
    
    private func setupGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        contentView.layer.addSublayer(gradientLayer)
    }
    
    private func setupLabels() {
        titleLabel.font = FontConstants.shortsCellTitleFont
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        contentView.addSubview(titleLabel)
        
        viewCountLabel.font = FontConstants.shortsCellViewCountFont
        viewCountLabel.textColor = .white
        viewCountLabel.adjustsFontSizeToFitWidth = true
        viewCountLabel.minimumScaleFactor = 0.8
        viewCountLabel.textAlignment = .left
        contentView.addSubview(viewCountLabel)
    }
    
    private func setupFrames() {
        let cellWidth = contentView.bounds.width
        let cellHeight = contentView.bounds.height
        
        thumbnailImageView.frame = contentView.bounds
        
        viewCountLabel.frame = CGRect(
            x: LayoutConstants.ShortsCell.padding,
            y: cellHeight - 16 - LayoutConstants.ShortsCell.padding,
            width: cellWidth - (LayoutConstants.ShortsCell.padding * 2),
            height: 16
        )
        
        let availableHeight = viewCountLabel.frame.minY - LayoutConstants.ShortsCell.textSpacing - LayoutConstants.ShortsCell.padding
        let titleSize = titleLabel.sizeThatFits(CGSize(width: cellWidth - (LayoutConstants.ShortsCell.padding * 2), height: availableHeight))
        
        titleLabel.frame = CGRect(
            x: LayoutConstants.ShortsCell.padding,
            y: viewCountLabel.frame.minY - LayoutConstants.ShortsCell.textSpacing - titleSize.height,
            width: cellWidth - (LayoutConstants.ShortsCell.padding * 2),
            height: titleSize.height
        )
    }
    
    private func updateGradient() {
        // Ensure gradient frame matches content bounds to prevent visual glitches
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = contentView.bounds
        CATransaction.commit()
    }
    
    // MARK: - Configuration
    func configure(with video: Video, at index: Int) {
        currentVideo = video
        titleLabel.text = video.title
        viewCountLabel.text = video.formattedViewCount
        
        // Set background color immediately
        thumbnailImageView.backgroundColor = ColorHelper.shortsBackgroundColor(for: video.id)
        
        setNeedsLayout()
    }
}
