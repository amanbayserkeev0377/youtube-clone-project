import UIKit

class ShortsPlayerCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let videoContainerView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let likeButton = UIButton()
    private let dislikeButton = UIButton()
    private let commentButton = UIButton()
    private let shareButton = UIButton()
    private let remixButton = UIButton()
    
    // Button labels
    private let likeLabel = UILabel()
    private let dislikeLabel = UILabel()
    private let commentLabel = UILabel()
    private let shareLabel = UILabel()
    private let remixLabel = UILabel()
    
    // Bottom info
    private let bottomInfoView = UIView()
    private let channelAvatarView = UIView()
    private let channelNameLabel = UILabel()
    private let subscribeButton = UIButton()
    private let videoTitleLabel = UILabel()
    
    // MARK: - Video Storage
    private var currentVideo: Video?
    
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
        
        // Update gradient frame to prevent glitches during scroll
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = contentView.bounds
        CATransaction.commit()
        
        // Apply colors after layout to ensure proper display
        if let video = currentVideo {
            videoContainerView.backgroundColor = ColorHelper.shortsBackgroundColor(for: video.id)
            channelAvatarView.backgroundColor = ColorHelper.avatarColor(for: video.channel.id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear data to prevent display issues
        currentVideo = nil
        channelNameLabel.text = nil
        videoTitleLabel.text = nil
        likeLabel.text = nil
        commentLabel.text = nil
        videoContainerView.backgroundColor = .systemGray5
        channelAvatarView.backgroundColor = .systemGray4
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        setupVideoContainer()
        setupRightButtons()
        setupBottomInfo()
    }
    
    private func setupVideoContainer() {
        videoContainerView.backgroundColor = .systemGray5 // Default background to prevent white flash
        contentView.addSubview(videoContainerView)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        videoContainerView.layer.addSublayer(gradientLayer)
    }
    
    private func setupRightButtons() {
        let buttons = [likeButton, dislikeButton, commentButton, shareButton, remixButton]
        let labels = [likeLabel, dislikeLabel, commentLabel, shareLabel, remixLabel]
        let buttonData: [(String, String)] = [
            ("hand.thumbsup", "like"),
            ("hand.thumbsdown", "dislike"),
            ("list.bullet.rectangle", "comment"),
            ("arrowshape.turn.up.right", "share"),
            ("arrow.trianglehead.2.clockwise", "remix")
        ]
        
        for (index, button) in buttons.enumerated() {
            let (iconName, _) = buttonData[index]
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
            
            button.setImage(UIImage(systemName: iconName, withConfiguration: config), for: .normal)
            button.tintColor = .white
            button.tag = index
            button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
            
            contentView.addSubview(button)
        }
        
        for (index, label) in labels.enumerated() {
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .white
            label.textAlignment = .center
            label.tag = index
            contentView.addSubview(label)
        }
        
        dislikeLabel.text = "Dislike"
        shareLabel.text = "Share"
        remixLabel.text = "Remix"
    }
    
    private func setupBottomInfo() {
        bottomInfoView.backgroundColor = .clear
        contentView.addSubview(bottomInfoView)
    
        channelAvatarView.backgroundColor = .systemGray4 // Default color to prevent white flash
        channelAvatarView.layer.cornerRadius = LayoutConstants.ShortsPlayerCell.avatarSize / 2
        bottomInfoView.addSubview(channelAvatarView)
        
        channelNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        channelNameLabel.textColor = .white
        bottomInfoView.addSubview(channelNameLabel)
        
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        subscribeButton.setTitleColor(.black, for: .normal)
        subscribeButton.backgroundColor = .white
        subscribeButton.layer.cornerRadius = 16
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        bottomInfoView.addSubview(subscribeButton)
        
        videoTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        videoTitleLabel.textColor = .white
        videoTitleLabel.numberOfLines = 2
        bottomInfoView.addSubview(videoTitleLabel)
    }
    
    private func setupFrames() {
        let width = contentView.bounds.width
        let height = contentView.bounds.height
    
        videoContainerView.frame = contentView.bounds
        
        setupRightButtonsFrames(containerWidth: width, containerHeight: height)
        setupBottomInfoFrames(containerWidth: width, containerHeight: height)
    }

    private func setupRightButtonsFrames(containerWidth: CGFloat, containerHeight: CGFloat) {
        let buttonX = containerWidth - LayoutConstants.ShortsPlayerCell.rightMargin - LayoutConstants.ShortsPlayerCell.buttonSize
        let buttonsArea = containerHeight - 100
        let buttonSpacing = LayoutConstants.ShortsPlayerCell.buttonSize + LayoutConstants.ShortsPlayerCell.labelHeight + LayoutConstants.ShortsPlayerCell.rightButtonsSpacing
        let startY = buttonsArea - (5 * buttonSpacing)
        
        let buttons = [likeButton, dislikeButton, commentButton, shareButton, remixButton]
        let labels = [likeLabel, dislikeLabel, commentLabel, shareLabel, remixLabel]
        
        for (index, button) in buttons.enumerated() {
            let y = startY + CGFloat(index) * buttonSpacing
            
            button.frame = CGRect(
                x: buttonX,
                y: y,
                width: LayoutConstants.ShortsPlayerCell.buttonSize,
                height: LayoutConstants.ShortsPlayerCell.buttonSize
            )
            labels[index].frame = CGRect(
                x: buttonX,
                y: y + LayoutConstants.ShortsPlayerCell.buttonSize,
                width: LayoutConstants.ShortsPlayerCell.buttonSize,
                height: LayoutConstants.ShortsPlayerCell.labelHeight
            )
        }
    }

    private func setupBottomInfoFrames(containerWidth: CGFloat, containerHeight: CGFloat) {
        bottomInfoView.frame = CGRect(
            x: 0,
            y: containerHeight - LayoutConstants.ShortsPlayerCell.bottomInfoHeight - LayoutConstants.ShortsPlayerCell.bottomMargin,
            width: containerWidth - 80,
            height: LayoutConstants.ShortsPlayerCell.bottomInfoHeight
        )
        
        channelAvatarView.frame = CGRect(
            x: LayoutConstants.ShortsPlayerCell.leftMargin,
            y: 0,
            width: LayoutConstants.ShortsPlayerCell.avatarSize,
            height: LayoutConstants.ShortsPlayerCell.avatarSize
        )
        
        let nameWidth = channelNameLabel.sizeThatFits(CGSize(width: 150, height: 20)).width
        channelNameLabel.frame = CGRect(x: 68, y: 10, width: nameWidth, height: 20)
        
        subscribeButton.frame = CGRect(x: channelNameLabel.frame.maxX + 12, y: 4, width: 90, height: 32)
        
        videoTitleLabel.frame = CGRect(
            x: LayoutConstants.ShortsPlayerCell.leftMargin,
            y: 48,
            width: bottomInfoView.bounds.width - 24,
            height: 40
        )
    }
    
    func configure(with video: Video, at index: Int) {
        currentVideo = video
        channelNameLabel.text = video.channel.name
        videoTitleLabel.text = video.title
        
        likeLabel.text = ColorHelper.formatCount(video.likeCount)
        commentLabel.text = ColorHelper.formatCount(video.commentCount)
        
        videoContainerView.backgroundColor = ColorHelper.shortsBackgroundColor(for: video.id)
        channelAvatarView.backgroundColor = ColorHelper.avatarColor(for: video.channel.id)
    }
    
    // MARK: - Button Actions
    @objc private func actionButtonTapped(_ sender: UIButton) {
        let actions = ["Like", "Dislike", "Comment", "Share", "Remix"]
        print("\(actions[sender.tag]) button tapped")
    }
    
    @objc private func subscribeButtonTapped() {
        print("Subscribe button tapped")
    }
}
