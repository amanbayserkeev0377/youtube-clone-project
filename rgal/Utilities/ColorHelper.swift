import UIKit

struct ColorHelper {
    
    private static let shortsColors: [UIColor] = [
        .systemRed, .systemMint, .systemIndigo, .systemCyan,
        .systemGreen, .systemOrange, .systemPurple, .systemPink,
        .systemTeal, .systemYellow, .systemBrown, .systemGray
    ]
    
    private static let avatarColors: [UIColor] = [
        .systemPink, .systemTeal, .systemIndigo, .systemMint, .systemCyan
    ]
    
    static func shortsBackgroundColor(for videoId: String) -> UIColor {
        let index = abs(videoId.hashValue) % shortsColors.count
        return shortsColors[index]
    }

    static func avatarColor(for channelId: String) -> UIColor {
        let index = abs(channelId.hashValue) % avatarColors.count
        return avatarColors[index]
    }
    
    static func formatCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return "\(count / 1_000_000)M"
        } else if count >= 1_000 {
            return "\(count / 1_000)K"
        } else {
            return "\(count)"
        }
    }
}
