import Foundation

// MARK: - Mock Data Service Protocol
protocol DataServiceProtocol {
    func getFilters() -> [String]
    func getChannels() -> [Channel]
    func getShortsVideos() -> [Video]
    func getVideos() -> [Video]
}

// MARK: - Mock Data Service Implementation
class MockDataService: DataServiceProtocol {
    
    static let shared = MockDataService()
    
    private init() {}
    
    // MARK: - Filters
    func getFilters() -> [String] {
        return ["All", "Gaming", "Music", "News", "Podcasts", "Tech", "Entertainment"]
    }
    
    // MARK: - Channels
    func getChannels() -> [Channel] {
        return [
            Channel(id: "1", name: "MrBeast", avatarURL: "mrbeast_avatar", subscriberCount: 180_000_000),
            Channel(id: "2", name: "Роман Галь", avatarURL: "roman_avatar", subscriberCount: 2_000_000),
            Channel(id: "3", name: "вДудь", avatarURL: "vdud_avatar", subscriberCount: 10_200_000),
            Channel(id: "4", name: "george hotz", avatarURL: "george_avatar", subscriberCount: 212_000),
            Channel(id: "5", name: "Wylsacom", avatarURL: "wylsacom_avatar", subscriberCount: 11_500_000),
            Channel(id: "6", name: "Apple", avatarURL: "apple_avatar", subscriberCount: 17_800_000),
            Channel(id: "7", name: "MKBHD", avatarURL: "mkbhd_avatar", subscriberCount: 18_200_000),
            Channel(id: "8", name: "Linus Tech Tips", avatarURL: "linus_avatar", subscriberCount: 15_400_000)
        ]
    }
    
    // MARK: - Shorts Videos
    func getShortsVideos() -> [Video] {
        let channels = getChannels()
        
        return [
            Video(
                id: "short1",
                title: "Лайфхак с iPhone 😱",
                description: "Скрытая функция iOS",
                thumbnailURL: "short1_thumb",
                duration: "0:15",
                viewCount: 2_400_000,
                uploadDate: Date().addingTimeInterval(-1800),
                channel: channels[4], // Wylsacom
                likeCount: 189_000,
                commentCount: 12_100,
                category: nil
            ),
            Video(
                id: "short2",
                title: "Кот играет в VR 🐱",
                description: "Смешное видео",
                thumbnailURL: "short2_thumb",
                duration: "0:23",
                viewCount: 5_600_000,
                uploadDate: Date().addingTimeInterval(-3600),
                channel: channels[0], // MrBeast
                likeCount: 456_000,
                commentCount: 23_400,
                category: nil
            ),
            Video(
                id: "short3",
                title: "Готовлю за 30 секунд",
                description: "Быстрый рецепт",
                thumbnailURL: "short3_thumb",
                duration: "0:29",
                viewCount: 1_200_000,
                uploadDate: Date().addingTimeInterval(-7200),
                channel: channels[1], // Роман Галь
                likeCount: 67_000,
                commentCount: 3_200,
                category: nil
            ),
            Video(
                id: "short4",
                title: "AI рисует портрет",
                description: "Нейросеть за 10 секунд",
                thumbnailURL: "short4_thumb",
                duration: "0:12",
                viewCount: 3_800_000,
                uploadDate: Date().addingTimeInterval(-10800),
                channel: channels[5], // Apple
                likeCount: 245_000,
                commentCount: 18_700,
                category: nil
            ),
            Video(
                id: "short5",
                title: "Танец на крыше 💃",
                description: "Безумный челлендж",
                thumbnailURL: "short5_thumb",
                duration: "0:18",
                viewCount: 8_900_000,
                uploadDate: Date().addingTimeInterval(-14400),
                channel: channels[2], // вДудь
                likeCount: 678_000,
                commentCount: 45_600,
                category: nil
            ),
            Video(
                id: "short6",
                title: "Как заработать в 16 лет",
                description: "Мой первый доход",
                thumbnailURL: "short6_thumb",
                duration: "0:45",
                viewCount: 2_100_000,
                uploadDate: Date().addingTimeInterval(-18000),
                channel: channels[1], // Роман Галь
                likeCount: 123_000,
                commentCount: 8_900,
                category: nil
            ),
            Video(
                id: "short7",
                title: "Пранк над братом 😂",
                description: "Его реакция бесценна",
                thumbnailURL: "short7_thumb",
                duration: "0:25",
                viewCount: 4_500_000,
                uploadDate: Date().addingTimeInterval(-21600),
                channel: channels[0], // MrBeast
                likeCount: 334_000,
                commentCount: 28_100,
                category: nil
            ),
            Video(
                id: "short8",
                title: "MacBook vs PC Gaming",
                description: "Честное сравнение",
                thumbnailURL: "short8_thumb",
                duration: "0:38",
                viewCount: 1_800_000,
                uploadDate: Date().addingTimeInterval(-25200),
                channel: channels[6], // MKBHD
                likeCount: 89_000,
                commentCount: 5_600,
                category: nil
            ),
            Video(
                id: "short9",
                title: "Квартира за 200к в месяц",
                description: "Обзор элитного жилья",
                thumbnailURL: "short9_thumb",
                duration: "0:52",
                viewCount: 6_700_000,
                uploadDate: Date().addingTimeInterval(-28800),
                channel: channels[2], // вДудь
                likeCount: 445_000,
                commentCount: 34_200,
                category: nil
            ),
            Video(
                id: "short10",
                title: "Учу собаку программировать",
                description: "Python для животных",
                thumbnailURL: "short10_thumb",
                duration: "0:19",
                viewCount: 3_200_000,
                uploadDate: Date().addingTimeInterval(-32400),
                channel: channels[3], // george hotz
                likeCount: 198_000,
                commentCount: 15_300,
                category: nil
            ),
            Video(
                id: "short11",
                title: "Makeup за 1 минуту ✨",
                description: "Быстрый утренний образ",
                thumbnailURL: "short11_thumb",
                duration: "0:58",
                viewCount: 4_100_000,
                uploadDate: Date().addingTimeInterval(-36000),
                channel: channels[7], // Linus Tech Tips
                likeCount: 267_000,
                commentCount: 19_800,
                category: nil
            ),
            Video(
                id: "short12",
                title: "Дрон снимает закат",
                description: "Красота природы",
                thumbnailURL: "short12_thumb",
                duration: "0:31",
                viewCount: 2_900_000,
                uploadDate: Date().addingTimeInterval(-39600),
                channel: channels[4], // Wylsacom
                likeCount: 145_000,
                commentCount: 7_400,
                category: nil
            ),
            Video(
                id: "short13",
                title: "Фокус с картами 🎴",
                description: "Секрет раскрыт",
                thumbnailURL: "short13_thumb",
                duration: "0:22",
                viewCount: 1_600_000,
                uploadDate: Date().addingTimeInterval(-43200),
                channel: channels[6], // MKBHD
                likeCount: 78_000,
                commentCount: 4_100,
                category: nil
            ),
            Video(
                id: "short14",
                title: "Строю дом из Lego",
                description: "Минимализм в архитектуре",
                thumbnailURL: "short14_thumb",
                duration: "0:47",
                viewCount: 3_500_000,
                uploadDate: Date().addingTimeInterval(-46800),
                channel: channels[0], // MrBeast
                likeCount: 223_000,
                commentCount: 12_600,
                category: nil
            ),
            Video(
                id: "short15",
                title: "Реакция мамы на TikTok",
                description: "Первый раз в соцсетях",
                thumbnailURL: "short15_thumb",
                duration: "0:34",
                viewCount: 7_200_000,
                uploadDate: Date().addingTimeInterval(-50400),
                channel: channels[2], // вДудь
                likeCount: 567_000,
                commentCount: 41_300,
                category: nil
            ),
            Video(
                id: "short16",
                title: "Уличная еда в Токио 🍜",
                description: "Лучшие места города",
                thumbnailURL: "short16_thumb",
                duration: "0:41",
                viewCount: 2_800_000,
                uploadDate: Date().addingTimeInterval(-54000),
                channel: channels[7], // Linus Tech Tips
                likeCount: 156_000,
                commentCount: 8_900,
                category: nil
            ),
            Video(
                id: "short17",
                title: "Кот vs Roomba",
                description: "Эпичная битва",
                thumbnailURL: "short17_thumb",
                duration: "0:16",
                viewCount: 4_900_000,
                uploadDate: Date().addingTimeInterval(-57600),
                channel: channels[5], // Apple
                likeCount: 378_000,
                commentCount: 26_700,
                category: nil
            ),
            Video(
                id: "short18",
                title: "Делаю слайм дома",
                description: "Простой рецепт",
                thumbnailURL: "short18_thumb",
                duration: "0:27",
                viewCount: 1_400_000,
                uploadDate: Date().addingTimeInterval(-61200),
                channel: channels[3], // george hotz
                likeCount: 89_000,
                commentCount: 5_200,
                category: nil
            ),
            Video(
                id: "short19",
                title: "Бабушка играет в CS:GO",
                description: "80 лет и про геймер",
                thumbnailURL: "short19_thumb",
                duration: "0:35",
                viewCount: 6_100_000,
                uploadDate: Date().addingTimeInterval(-64800),
                channel: channels[6], // MKBHD
                likeCount: 445_000,
                commentCount: 32_100,
                category: nil
            ),
            Video(
                id: "short20",
                title: "Мой день в Apple Park",
                description: "Экскурсия по штаб-квартире",
                thumbnailURL: "short20_thumb",
                duration: "0:59",
                viewCount: 8_200_000,
                uploadDate: Date().addingTimeInterval(-68400),
                channel: channels[5], // Apple
                likeCount: 623_000,
                commentCount: 47_200,
                category: nil
            )
        ]
    }
    
    // MARK: - Regular Videos
    func getVideos() -> [Video] {
        let channels = getChannels()
        
        return [
            Video(
                id: "1",
                title: "$1 vs $100,000,000 Car!",
                description: "I bought cars ranging from $1 to $100,000,000",
                thumbnailURL: "video1_thumb",
                duration: "38:24",
                viewCount: 45_000_000,
                uploadDate: Date().addingTimeInterval(-86400 * 2),
                channel: channels[0],
                likeCount: 1_200_000,
                commentCount: 89_000,
                category: .entertainment
            ),
            Video(
                id: "2",
                title: "Попробовал самую дорогую еду в мире",
                description: "Еда за миллион рублей существует?",
                thumbnailURL: "video2_thumb",
                duration: "12:45",
                viewCount: 3_200_000,
                uploadDate: Date().addingTimeInterval(-3600 * 5),
                channel: channels[2],
                likeCount: 180_000,
                commentCount: 12_000,
                category: .entertainment
            ),
            Video(
                id: "3",
                title: "iPhone 17 Pro Max полный обзор",
                description: "Все что нужно знать о новом iPhone",
                thumbnailURL: "video3_thumb",
                duration: "15:30",
                viewCount: 890_000,
                uploadDate: Date().addingTimeInterval(-3600 * 12),
                channel: channels[4],
                likeCount: 45_000,
                commentCount: 3_200,
                category: .tech
            ),
            Video(
                id: "4",
                title: "iOS 18 Review: The Complete Guide",
                description: "Everything new in iOS 18 and how it changes your iPhone experience",
                thumbnailURL: "video4_thumb",
                duration: "18:45",
                viewCount: 2_100_000,
                uploadDate: Date().addingTimeInterval(-3600 * 8),
                channel: channels[5],
                likeCount: 95_000,
                commentCount: 8_500,
                category: .tech
            ),
            Video(
                id: "5",
                title: "WWDC 2025 Keynote Highlights",
                description: "All the biggest announcements from Apple's developer conference",
                thumbnailURL: "video5_thumb",
                duration: "25:12",
                viewCount: 1_800_000,
                uploadDate: Date().addingTimeInterval(-86400),
                channel: channels[6],
                likeCount: 78_000,
                commentCount: 5_600,
                category: .news
            ),
            Video(
                id: "6",
                title: "Coding Interview Tips That Actually Work",
                description: "From junior to senior developer - proven strategies",
                thumbnailURL: "video6_thumb",
                duration: "14:33",
                viewCount: 650_000,
                uploadDate: Date().addingTimeInterval(-3600 * 18),
                channel: channels[1],
                likeCount: 42_000,
                commentCount: 3_800,
                category: .news
            ),
            Video(
                id: "7",
                title: "Building the Future of Technology",
                description: "Startup founders share their vision for the next decade",
                thumbnailURL: "video7_thumb",
                duration: "32:18",
                viewCount: 420_000,
                uploadDate: Date().addingTimeInterval(-86400 * 3),
                channel: channels[7],
                likeCount: 28_000,
                commentCount: 2_100,
                category: .gaming
            ),
            Video(
                id: "8",
                title: "Разбор интервью в Google",
                description: "Как я получил оффер в Big Tech компанию",
                thumbnailURL: "video8_thumb",
                duration: "11:24",
                viewCount: 780_000,
                uploadDate: Date().addingTimeInterval(-3600 * 14),
                channel: channels[3],
                likeCount: 52_000,
                commentCount: 4_200,
                category: .gaming
            ),
            Video(
                id: "9",
                title: "Ultimate Gaming Setup 2025",
                description: "The most expensive gaming setup money can buy",
                thumbnailURL: "video9_thumb",
                duration: "16:47",
                viewCount: 1_600_000,
                uploadDate: Date().addingTimeInterval(-3600 * 6),
                channel: channels[6],
                likeCount: 87_000,
                commentCount: 6_700,
                category: .music
            ),
            Video(
                id: "10",
                title: "MacBook Air M3 vs MacBook Pro M3",
                description: "Which one should you buy in 2025?",
                thumbnailURL: "video10_thumb",
                duration: "13:55",
                viewCount: 940_000,
                uploadDate: Date().addingTimeInterval(-3600 * 10),
                channel: channels[4],
                likeCount: 56_000,
                commentCount: 4_100,
                category: .music
            ),
            Video(
                id: "11",
                title: "Swift 6.0 Complete Tutorial",
                description: "Everything new in Swift 6.0 for iOS developers",
                thumbnailURL: "video11_thumb",
                duration: "28:30",
                viewCount: 320_000,
                uploadDate: Date().addingTimeInterval(-86400 * 4),
                channel: channels[1],
                likeCount: 18_000,
                commentCount: 1_500,
                category: .podcasts
            ),
            Video(
                id: "12",
                title: "Живая передача: Обсуждаем новости технологий",
                description: "Прямой эфир с экспертами",
                thumbnailURL: "video12_thumb",
                duration: "17:37",
                viewCount: 15_000,
                uploadDate: Date().addingTimeInterval(-1800),
                channel: channels[2],
                likeCount: 2_800,
                commentCount: 450,
                category: .podcasts
            )
        ]
    }
}
