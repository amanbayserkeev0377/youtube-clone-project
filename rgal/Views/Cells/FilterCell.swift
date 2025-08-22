import UIKit

class FilterCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    
    private struct Layout {
        static let cornerRadius: CGFloat = 12
        static let verticalPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 12
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
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
    
    private func setupUI() {
        layer.cornerRadius = Layout.cornerRadius
        clipsToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        updateAppearance()
    }
    
    private func setupFrames() {
        titleLabel.frame = CGRect(
            x: Layout.horizontalPadding,
            y: Layout.verticalPadding,
            width: contentView.bounds.width - (Layout.horizontalPadding * 2),
            height: contentView.bounds.height - (Layout.verticalPadding * 2)
        )
    }
    
    private func updateAppearance() {
        if isSelected {
            backgroundColor = .label
            titleLabel.textColor = .systemBackground
        } else {
            backgroundColor = .systemGray6
            titleLabel.textColor = .label
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
