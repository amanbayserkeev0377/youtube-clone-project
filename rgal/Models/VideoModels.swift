import Foundation

struct Video {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: String
    let duration: String
    let viewCount: Int
    let uploadDate: Date
    let channel: Channel
    let likeCount: Int
    let commentCount: Int
    let category: VideoCategory?
    
    // MARK: - Helper Methods
    
    var formattedViewCount: String {
        if viewCount >= 1_000_000 {
            return "\(viewCount / 1_000_000)M views"
        } else if viewCount >= 1_000 {
            return "\(viewCount / 1_000)K views"
        } else {
            return "\(viewCount) views"
        }
    }
    
    var timeAgoText: String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(uploadDate)
        
        if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes) min ago"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours) hr ago"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days) d ago"
        }
    }
}

enum VideoCategory: String, CaseIterable {
    case gaming = "Gaming"
    case music = "Music"
    case news = "News"
    case podcasts = "Podcasts"
    case tech = "Tech"
    case entertainment = "Entertainment"
}

struct Channel {
    let id: String
    let name: String
    let avatarURL: String
    let subscriberCount: Int
    
    var formattedSubscriberCount: String {
        if subscriberCount >= 1_000_000 {
            return "\(subscriberCount / 1_000_000)M subscribers"
        } else if subscriberCount >= 1_000 {
            return "\(subscriberCount / 1_000)K subscribers"
        } else {
            return "\(subscriberCount) subscribers"
        }
    }
}
