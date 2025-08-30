import UIKit

struct GradientHelper {
    
    // MARK: - Gradient Caching
    private static var thumbnailGradientCache: [String: [CGColor]] = [:]
    private static var avatarGradientCache: [String: [CGColor]] = [:]
    
    // MARK: - Gradient Arrays
    private static let thumbnailGradients: [[CGColor]] = [
        [UIColor.systemRed.cgColor, UIColor.systemOrange.cgColor],
        [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor],
        [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor],
        [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor],
        [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor],
        [UIColor.systemTeal.cgColor, UIColor.systemCyan.cgColor]
    ]
    
    private static let avatarGradients: [[CGColor]] = [
        [UIColor.systemPink.cgColor, UIColor.systemRed.cgColor],
        [UIColor.systemIndigo.cgColor, UIColor.systemBlue.cgColor],
        [UIColor.systemMint.cgColor, UIColor.systemGreen.cgColor],
        [UIColor.systemCyan.cgColor, UIColor.systemTeal.cgColor],
        [UIColor.systemBrown.cgColor, UIColor.systemOrange.cgColor],
        [UIColor.systemGray.cgColor, UIColor.systemGray2.cgColor]
    ]
    
    // MARK: - Optimized Gradient Methods
    static func thumbnailGradient(for videoId: String) -> [CGColor] {
        // Check cache first for better performance
        if let cachedGradient = thumbnailGradientCache[videoId] {
            return cachedGradient
        }
        
        let index = abs(videoId.hashValue) % thumbnailGradients.count
        let gradient = thumbnailGradients[index]
        
        // Cache the result
        thumbnailGradientCache[videoId] = gradient
        
        return gradient
    }
    
    static func avatarGradient(for channelId: String) -> [CGColor] {
        // Check cache first for better performance
        if let cachedGradient = avatarGradientCache[channelId] {
            return cachedGradient
        }
        
        let index = abs(channelId.hashValue) % avatarGradients.count
        let gradient = avatarGradients[index]
        
        // Cache the result
        avatarGradientCache[channelId] = gradient
        
        return gradient
    }
    
    // MARK: - Cache Management
    static func clearCache() {
        thumbnailGradientCache.removeAll()
        avatarGradientCache.removeAll()
    }
}
