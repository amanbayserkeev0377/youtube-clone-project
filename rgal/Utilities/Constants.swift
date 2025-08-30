import UIKit

// MARK: - Cell Identifiers
enum CellIdentifier {
    static let filterCell = "FilterCell"
    static let shortsCell = "ShortsCell"
    static let videoCell = "VideoCell"
    static let shortsPlayerCell = "ShortsPlayerCell"
}

// MARK: - Supplementary View Identifiers
enum SupplementaryViewIdentifier {
    static let shortsHeader = "ShortsHeader"
}

// MARK: - Layout Constants
enum LayoutConstants {
    
    // MARK: - Home View
    enum Home {
        static let navigationBarHeight: CGFloat = 44
        static let horizontalPadding: CGFloat = 16
        static let buttonSize: CGFloat = 24
        static let buttonSpacing: CGFloat = 16
        static let logoWidth: CGFloat = 92
        static let logoHeight: CGFloat = 28
    }
    
    // MARK: - Shorts Header View
    enum ShortsHeader {
        static let iconPadding: CGFloat = 4
        static let iconSize: CGFloat = 24
        static let iconLabelSpacing: CGFloat = 8
        static let labelHeight: CGFloat = 24
    }
    
    // MARK: - Filter Cell
    enum FilterCell {
        static let cornerRadius: CGFloat = 12
        static let verticalPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 8
    }
    
    // MARK: - Shorts Cell
    enum ShortsCell {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 8
        static let textSpacing: CGFloat = 2
        static let viewCountMinWidth: CGFloat = 35
    }
    
    // MARK: - Video Cell
    enum VideoCell {
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
    
    // MARK: - Shorts Player Cell
    enum ShortsPlayerCell {
        static let rightButtonsWidth: CGFloat = 60
        static let rightButtonsSpacing: CGFloat = 12
        static let bottomInfoHeight: CGFloat = 140
        static let avatarSize: CGFloat = 40
        static let buttonSize: CGFloat = 50
        static let rightMargin: CGFloat = 8
        static let bottomMargin: CGFloat = 50
        static let leftMargin: CGFloat = 16
        static let labelHeight: CGFloat = 16
        static let buttonLabelSpacing: CGFloat = 0
    }
}

// MARK: - Font Constants
enum FontConstants {
    static let filterCellFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    static let shortsCellTitleFont = UIFont.systemFont(ofSize: 11, weight: .medium)
    static let shortsCellViewCountFont = UIFont.systemFont(ofSize: 10, weight: .medium)
    static let shortsHeaderFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let videoCellTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let videoCellInfoFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let videoCellDurationFont = UIFont.systemFont(ofSize: 12, weight: .medium)
}

// MARK: - Collection View Layout Constants
enum CollectionLayoutConstants {
    
    // MARK: - Filters Section
    enum Filters {
        static let height: CGFloat = 40
        static let itemSpacing: CGFloat = 8
        static let estimatedWidth: CGFloat = 1000
        static let contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        static let extraPadding: CGFloat = 24
    }
    
    // MARK: - Shorts Section
    enum Shorts {
        static let itemWidth: CGFloat = 140
        static let itemHeight: CGFloat = 240
        static let interGroupSpacing: CGFloat = 8
        static let contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 0)
        static let headerHeight: CGFloat = 32
    }
    
    // MARK: - Videos Section
    enum Videos {
        static let itemHeight: CGFloat = 330
        static let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
    }
}
