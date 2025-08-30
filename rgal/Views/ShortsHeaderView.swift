import UIKit

class ShortsHeaderView: UICollectionReusableView {
    
    // MARK: - UI Elements
    private let shortsIcon = UIImageView()
    private let shortsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        shortsIcon.image = UIImage(named: "youtube_shorts")
        shortsIcon.contentMode = .scaleAspectFit
        addSubview(shortsIcon)
        
        shortsLabel.text = "Shorts"
        shortsLabel.font = FontConstants.shortsHeaderFont
        shortsLabel.textColor = .label
        addSubview(shortsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shortsIcon.frame = CGRect(
            x: LayoutConstants.ShortsHeader.iconPadding,
            y: LayoutConstants.ShortsHeader.iconPadding,
            width: LayoutConstants.ShortsHeader.iconSize,
            height: LayoutConstants.ShortsHeader.iconSize
        )
        
        let labelSize = shortsLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: LayoutConstants.ShortsHeader.labelHeight))
        shortsLabel.frame = CGRect(
            x: shortsIcon.frame.maxX + LayoutConstants.ShortsHeader.iconLabelSpacing,
            y: LayoutConstants.ShortsHeader.iconPadding,
            width: labelSize.width,
            height: LayoutConstants.ShortsHeader.labelHeight
        )
    }
}
