import UIKit

class ShortsHeaderView: UICollectionReusableView {
    
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
        shortsLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        shortsLabel.textColor = .label
        addSubview(shortsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shortsIcon.frame = CGRect(x: 4, y: 4, width: 24, height: 24)
        
        let labelSize = shortsLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24))
        shortsLabel.frame = CGRect(
            x: shortsIcon.frame.maxX + 8,
            y: 4,
            width: labelSize.width,
            height: 24
        )
    }
}
