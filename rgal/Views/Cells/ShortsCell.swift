import UIKit

class ShortsCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let viewCountLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Constants
    private struct Layout {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 8
        static let textSpacing: CGFloat = 2
        static let viewCountMinWidth: CGFloat = 35
    }
    
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
        updateGradient()
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.layer.cornerRadius = Layout.cornerRadius
        contentView.clipsToBounds = true
        
        setupThumbnail()
        setupGradient()
        setupLabels()
    }
    
    private func setupThumbnail() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
    }
    
    private func setupGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        contentView.layer.addSublayer(gradientLayer)
    }
    
    private func setupLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        contentView.addSubview(titleLabel)
        
        viewCountLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
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
            x: Layout.padding,
            y: cellHeight - 16 - Layout.padding,
            width: cellWidth - (Layout.padding * 2),
            height: 16
        )
        
        let availableHeight = viewCountLabel.frame.minY - Layout.textSpacing - Layout.padding
        let titleSize = titleLabel.sizeThatFits(CGSize(width: cellWidth - (Layout.padding * 2), height: availableHeight))
        
        titleLabel.frame = CGRect(
            x: Layout.padding,
            y: viewCountLabel.frame.minY - Layout.textSpacing - titleSize.height,
            width: cellWidth - (Layout.padding * 2),
            height: titleSize.height
        )
    }
    
    private func updateGradient() {
        gradientLayer.frame = contentView.bounds
    }
    
    // MARK: - Configuration
    func configure(with video: Video, at index: Int) {
        titleLabel.text = video.title
        viewCountLabel.text = video.formattedViewCount
        
        thumbnailImageView.backgroundColor = ColorHelper.shortsBackgroundColor(for: video.id)
        
        setNeedsLayout()
    }
}
