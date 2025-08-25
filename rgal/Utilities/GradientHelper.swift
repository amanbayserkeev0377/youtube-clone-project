import UIKit

struct GradientHelper {
    
    static func thumbnailGradient(for videoId: String) -> [CGColor] {
        let gradients: [[CGColor]] = [
            [UIColor.systemRed.cgColor, UIColor.systemOrange.cgColor],
            [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor],
            [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor],
            [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor],
            [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor],
            [UIColor.systemTeal.cgColor, UIColor.systemCyan.cgColor]
        ]
        let index = abs(videoId.hashValue) % gradients.count
        return gradients[index]
    }
    
    static func avatarGradient(for channelId: String) -> [CGColor] {
        let gradients: [[CGColor]] = [
            [UIColor.systemPink.cgColor, UIColor.systemRed.cgColor],
            [UIColor.systemIndigo.cgColor, UIColor.systemBlue.cgColor],
            [UIColor.systemMint.cgColor, UIColor.systemGreen.cgColor],
            [UIColor.systemCyan.cgColor, UIColor.systemTeal.cgColor],
            [UIColor.systemBrown.cgColor, UIColor.systemOrange.cgColor],
            [UIColor.systemGray.cgColor, UIColor.systemGray2.cgColor]
        ]
        let index = abs(channelId.hashValue) % gradients.count
        return gradients[index]
    }
}
