import UIKit

class VideoCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let thumbnailContainerView = UIView()
    private let durationLabel = UILabel()
    private let channelAvatarContainerView = UIView()
    private let titleLabel = UILabel()
    private let channelInfoLabel = UILabel()
    private let moreButton = UIButton()
    
    // MARK: - Constants
    private struct Layout {
        static let cellPadding: CGFloat = 12
        static let thumbnailAspectRatio: CGFloat = 16.0/9.0
        static let avatarSize: CGFloat = 36
        static let moreButtonSize: CGFloat = 24
        static let durationLabelHeight: CGFloat = 20
        static let spacingBetweenElements: CGFloat = 12
        static let textSpacing: CGFloat = 2
        static let horizontalPadding: CGFloat = 16
        static let durationPadding: CGFloat = 8
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeGradientLayers()
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
        contentView.addSubview(thumbnailContainerView)
        
        durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        durationLabel.textColor = .white
        durationLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        durationLabel.textAlignment = .center
        durationLabel.layer.cornerRadius = 4
        durationLabel.clipsToBounds = true
        thumbnailContainerView.addSubview(durationLabel)
    }
    
    private func setupChannelAvatar() {
        channelAvatarContainerView.clipsToBounds = true
        channelAvatarContainerView.layer.cornerRadius = Layout.avatarSize / 2
        contentView.addSubview(channelAvatarContainerView)
    }
    
    private func setupLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        channelInfoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    // MARK: = Frame Layout
    private func setupFrames() {
        let cellWidth = contentView.bounds.width
        let thumbnailWidth = cellWidth
        let thumbnailHeight = thumbnailWidth / Layout.thumbnailAspectRatio
        
        thumbnailContainerView.frame = CGRect(
            x: 0,
            y: Layout.cellPadding,
            width: thumbnailWidth,
            height: thumbnailHeight
        )
        
        let durationText = durationLabel.text ?? ""
        let durationSize = (durationText as NSString).size(withAttributes: [.font: durationLabel.font!])
        let durationWidth = max(35, durationSize.width + 8)
        
        durationLabel.frame = CGRect(
            x: thumbnailWidth - durationWidth - Layout.durationPadding,
            y: thumbnailHeight - Layout.durationLabelHeight - Layout.durationPadding,
            width: durationWidth,
            height: Layout.durationLabelHeight
        )
        
        let bottomSectionY = thumbnailContainerView.frame.maxY + Layout.spacingBetweenElements
        
        channelAvatarContainerView.frame = CGRect(
            x: Layout.horizontalPadding,
            y: bottomSectionY,
            width: Layout.avatarSize,
            height: Layout.avatarSize
        )
        
        moreButton.frame = CGRect(
            x: cellWidth - Layout.moreButtonSize - Layout.horizontalPadding,
            y: bottomSectionY,
            width: Layout.moreButtonSize,
            height: Layout.moreButtonSize
        )
        
        let textStartX = channelAvatarContainerView.frame.maxX + Layout.spacingBetweenElements
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
            y: titleLabel.frame.maxY + Layout.textSpacing,
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
        titleLabel.text = video.title
        durationLabel.text = " \(video.duration) "
        
        let channelText = video.channel.name
        let viewsText = video.formattedViewCount
        let timeText = video.timeAgoText
        
        channelInfoLabel.text = "\(channelText) • \(viewsText) • \(timeText)"
        
        setNeedsLayout()
        
        DispatchQueue.main.async { [weak self] in
            self?.applyGradients(for: video)
        }
    }
    
    private func applyGradients(for video: Video) {
        removeGradientLayers()
        
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
