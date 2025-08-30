import UIKit

class FilterCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
        
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
        
        backgroundConfig.cornerRadius = LayoutConstants.FilterCell.cornerRadius
        self.backgroundConfiguration = backgroundConfig
    }
    
    private func setupUI() {
        titleLabel.font = FontConstants.filterCellFont
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }
    
    private func setupFrames() {
        titleLabel.frame = CGRect(
            x: LayoutConstants.FilterCell.horizontalPadding,
            y: LayoutConstants.FilterCell.verticalPadding,
            width: contentView.bounds.width - (LayoutConstants.FilterCell.horizontalPadding * 2),
            height: contentView.bounds.height - (LayoutConstants.FilterCell.verticalPadding * 2)
        )
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        setNeedsUpdateConfiguration()
    }
}
