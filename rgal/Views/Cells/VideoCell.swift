import UIKit

class VideoCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let thumbnailContainerView = UIView()
    private let durationLabel = UILabel()
    private let channelAvatarContainerView = UIView()
    private let titleLabel = UILabel()
    private let channelInfoLabel = UILabel()
    private let moreButton = UIButton()
    
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
        
        // Apply gradients after frame is set to ensure proper sizing
        if let video = currentVideo {
            applyGradients(for: video)
        }
    }
    
    // MARK: - Video Storage
    private var currentVideo: Video?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentVideo = nil
        removeGradientLayers()
        
        // Reset to default colors to prevent flashing
        thumbnailContainerView.backgroundColor = .systemGray5
        channelAvatarContainerView.backgroundColor = .systemGray4
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        setupThumbnail()
        setupChannelAvatar()
        setupLabels()
        setupMoreButton()
    }
    
    private func setupThumbnail() {
        thumbnailContainerView.clipsToBounds = true
        // Set a default background color to avoid white flash
        thumbnailContainerView.backgroundColor = .systemGray5
        contentView.addSubview(thumbnailContainerView)
        
        durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        durationLabel.textColor = .white
        durationLabel.font = FontConstants.videoCellDurationFont
        durationLabel.textAlignment = .center
        durationLabel.layer.cornerRadius = 4
        durationLabel.clipsToBounds = true
        thumbnailContainerView.addSubview(durationLabel)
    }
    
    private func setupChannelAvatar() {
        channelAvatarContainerView.clipsToBounds = true
        channelAvatarContainerView.layer.cornerRadius = LayoutConstants.VideoCell.avatarSize / 2
        // Set a default background color to avoid white flash
        channelAvatarContainerView.backgroundColor = .systemGray4
        contentView.addSubview(channelAvatarContainerView)
    }
    
    private func setupLabels() {
        titleLabel.font = FontConstants.videoCellTitleFont
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        channelInfoLabel.font = FontConstants.videoCellInfoFont
        channelInfoLabel.textColor = .secondaryLabel
        channelInfoLabel.numberOfLines = 1
        contentView.addSubview(channelInfoLabel)
    }
    
    private func setupMoreButton() {
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .secondaryLabel
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        contentView.addSubview(moreButton)
    }
    
    // MARK: - Frame Layout
    private func setupFrames() {
        let cellWidth = contentView.bounds.width
        let thumbnailWidth = cellWidth
        let thumbnailHeight = thumbnailWidth / LayoutConstants.VideoCell.thumbnailAspectRatio
        
        thumbnailContainerView.frame = CGRect(
            x: 0,
            y: LayoutConstants.VideoCell.cellPadding,
            width: thumbnailWidth,
            height: thumbnailHeight
        )
        
        let durationText = durationLabel.text ?? ""
        let durationSize = (durationText as NSString).size(withAttributes: [.font: durationLabel.font!])
        let durationWidth = max(35, durationSize.width + 8)
        
        durationLabel.frame = CGRect(
            x: thumbnailWidth - durationWidth - LayoutConstants.VideoCell.durationPadding,
            y: thumbnailHeight - LayoutConstants.VideoCell.durationLabelHeight - LayoutConstants.VideoCell.durationPadding,
            width: durationWidth,
            height: LayoutConstants.VideoCell.durationLabelHeight
        )
        
        let bottomSectionY = thumbnailContainerView.frame.maxY + LayoutConstants.VideoCell.spacingBetweenElements
        
        channelAvatarContainerView.frame = CGRect(
            x: LayoutConstants.VideoCell.horizontalPadding,
            y: bottomSectionY,
            width: LayoutConstants.VideoCell.avatarSize,
            height: LayoutConstants.VideoCell.avatarSize
        )
        
        moreButton.frame = CGRect(
            x: cellWidth - LayoutConstants.VideoCell.moreButtonSize - LayoutConstants.VideoCell.horizontalPadding,
            y: bottomSectionY,
            width: LayoutConstants.VideoCell.moreButtonSize,
            height: LayoutConstants.VideoCell.moreButtonSize
        )
        
        let textStartX = channelAvatarContainerView.frame.maxX + LayoutConstants.VideoCell.spacingBetweenElements
        let textEndX = moreButton.frame.minX - 8
        let textWidth = textEndX - textStartX
        
        let titleSize = titleLabel.sizeThatFits(CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude))
        titleLabel.frame = CGRect(
            x: textStartX,
            y: bottomSectionY,
            width: textWidth,
            height: titleSize.height
        )
        
        let channelInfoSize = channelInfoLabel.sizeThatFits(CGSize(width: textWidth, height: 20))
        channelInfoLabel.frame = CGRect(
            x: textStartX,
            y: titleLabel.frame.maxY + LayoutConstants.VideoCell.textSpacing,
            width: textWidth,
            height: channelInfoSize.height
        )
    }
    
    // MARK: - Gradient Management
    private func removeGradientLayers() {
        thumbnailContainerView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        channelAvatarContainerView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
    }
    
    private func addGradient(to view: UIView, colors: [CGColor], cornerRadius: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = cornerRadius
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Configuration
    func configure(with video: Video) {
        currentVideo = video
        
        titleLabel.text = video.title
        durationLabel.text = " \(video.duration) "
        
        let channelText = video.channel.name
        let viewsText = video.formattedViewCount
        let timeText = video.timeAgoText
        
        channelInfoLabel.text = "\(channelText) • \(viewsText) • \(timeText)"
        
        // Apply gradients immediately and ensure they're applied after layout
        applyGradients(for: video)
        setNeedsLayout()
    }
    
    private func applyGradients(for video: Video) {
        // Ensure we have proper bounds before applying gradients
        guard thumbnailContainerView.bounds.width > 0 && thumbnailContainerView.bounds.height > 0 else {
            return
        }
        
        // Remove old gradients first
        removeGradientLayers()
        
        // Apply new gradients
        let thumbnailColors = GradientHelper.thumbnailGradient(for: video.id)
        addGradient(to: thumbnailContainerView, colors: thumbnailColors)
        
        let avatarColors = GradientHelper.avatarGradient(for: video.channel.id)
        addGradient(to: channelAvatarContainerView, colors: avatarColors, cornerRadius: 18)
    }
    
    // MARK: - Actions
    @objc private func moreButtonTapped() {
        print("More button tapped - показать контекстное меню видео")
    }
}
