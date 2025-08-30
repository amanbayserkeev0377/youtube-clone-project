import UIKit

struct ColorHelper {
    
    // MARK: - Color Caching
    private static var shortsColorCache: [String: UIColor] = [:]
    private static var avatarColorCache: [String: UIColor] = [:]
    
    // MARK: - Color Arrays
    private static let shortsColors: [UIColor] = [
        .systemRed, .systemMint, .systemIndigo, .systemCyan,
        .systemGreen, .systemOrange, .systemPurple, .systemPink,
        .systemTeal, .systemYellow, .systemBrown, .systemGray
    ]
    
    private static let avatarColors: [UIColor] = [
        .systemPink, .systemTeal, .systemIndigo, .systemMint, .systemCyan
    ]
    
    // MARK: - Optimized Color Methods
    static func shortsBackgroundColor(for videoId: String) -> UIColor {
        if let cachedColor = shortsColorCache[videoId] {
            return cachedColor
        }
        
        let index = abs(videoId.hashValue) % shortsColors.count
        let color = shortsColors[index]
        
        shortsColorCache[videoId] = color
        
        return color
    }

    static func avatarColor(for channelId: String) -> UIColor {
        if let cachedColor = avatarColorCache[channelId] {
            return cachedColor
        }
        
        let index = abs(channelId.hashValue) % avatarColors.count
        let color = avatarColors[index]
        
        avatarColorCache[channelId] = color
        
        return color
    }
    
    // MARK: - Count Formatting
    static func formatCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return "\(count / 1_000_000)M"
        } else if count >= 1_000 {
            return "\(count / 1_000)K"
        } else {
            return "\(count)"
        }
    }
    
    // MARK: - Cache Management
    static func clearCache() {
        shortsColorCache.removeAll()
        avatarColorCache.removeAll()
    }
}
