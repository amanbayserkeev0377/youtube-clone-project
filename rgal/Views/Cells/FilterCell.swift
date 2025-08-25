import UIKit

class FilterCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    
    private struct Layout {
        static let cornerRadius: CGFloat = 12
        static let verticalPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 8
    }
        
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
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        
        if state.isSelected || state.isHighlighted {
            backgroundConfig.backgroundColor = UIColor.label
            titleLabel.textColor = UIColor.systemBackground
        } else {
            backgroundConfig.backgroundColor = UIColor.systemGray6
            titleLabel.textColor = UIColor.label
        }
        
        backgroundConfig.cornerRadius = Layout.cornerRadius
        self.backgroundConfiguration = backgroundConfig
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }
    
    private func setupFrames() {
        titleLabel.frame = CGRect(
            x: Layout.horizontalPadding,
            y: Layout.verticalPadding,
            width: contentView.bounds.width - (Layout.horizontalPadding * 2),
            height: contentView.bounds.height - (Layout.verticalPadding * 2)
        )
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        setNeedsUpdateConfiguration()
    }
}
