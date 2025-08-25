import UIKit

enum HomeSection: Int, CaseIterable {
    case filters
    case shorts
    case videos
}

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private let customNavBar = UIView()
    private let logoImageView = UIImageView()
    private let castButton = UIButton()
    private let notificationButton = UIButton()
    private let searchButton = UIButton()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    //MARK: - Data
    
    private let filters = ["All", "Gaming", "Music", "News", "Podcasts", "Tech", "Entertainment"]
    private var selectedFilterIndex = 0
    private var filteredVideos: [Video] = []
        
    // MARK: - Constants
    
    private struct Layout {
        static let navBarHeight: CGFloat = 44
        static let horizontalPadding: CGFloat = 16
        static let buttonSize: CGFloat = 24
        static let buttonSpacing: CGFloat = 16
        static let logoWidth: CGFloat = 92
        static let logoHeight: CGFloat = 28
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        updateFilteredContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        setupCustomNavBar()
        view.addSubview(collectionView)
    }
        
    private func setupCustomNavBar() {
        customNavBar.backgroundColor = .systemBackground
        view.addSubview(customNavBar)
        
        logoImageView.image = UIImage(named: "youtube_logo")
        logoImageView.contentMode = .scaleAspectFit
        customNavBar.addSubview(logoImageView)
        
        setupNavButtons()
    }
    
    private func setupNavButtons() {
        castButton.setImage(UIImage(systemName: "airplay.video"), for: .normal)
        castButton.tintColor = .label
        castButton.addTarget(self, action: #selector(castButtonTapped), for: .touchUpInside)
        customNavBar.addSubview(castButton)
        
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = .label
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        customNavBar.addSubview(notificationButton)
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .label
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        customNavBar.addSubview(searchButton)
    }
    
    private func setupCollectionView() {
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        collectionView.register(ShortsCell.self, forCellWithReuseIdentifier: "ShortsCell")
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        
        collectionView.register(ShortsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ShortsHeader")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupFrames() {
        let safeAreaTop = view.safeAreaInsets.top
        let screenWidth = view.bounds.width
        
        customNavBar.frame = CGRect(x: 0, y: safeAreaTop, width: screenWidth, height: Layout.navBarHeight)
        
        logoImageView.frame = CGRect(
            x: Layout.horizontalPadding,
            y: (Layout.navBarHeight - Layout.logoHeight) / 2,
            width: Layout.logoWidth,
            height: Layout.logoHeight
        )
        
        searchButton.frame = CGRect(
            x: screenWidth - Layout.horizontalPadding - Layout.buttonSize,
            y: (Layout.navBarHeight - Layout.buttonSize) / 2,
            width: Layout.buttonSize,
            height: Layout.buttonSize
        )
        
        notificationButton.frame = CGRect(
            x: searchButton.frame.minX - Layout.buttonSpacing - Layout.buttonSize,
            y: (Layout.navBarHeight - Layout.buttonSize) / 2,
            width: Layout.buttonSize,
            height: Layout.buttonSize
        )
        
        castButton.frame = CGRect(
            x: notificationButton.frame.minX - Layout.buttonSpacing - Layout.buttonSize,
            y: (Layout.navBarHeight - Layout.buttonSize) / 2,
            width: Layout.buttonSize,
            height: Layout.buttonSize
        )
        
        collectionView.frame = CGRect(
            x: 0,
            y: safeAreaTop + Layout.navBarHeight,
            width: screenWidth,
            height: view.bounds.height - safeAreaTop - Layout.navBarHeight - view.safeAreaInsets.bottom
        )
        
    }
        
    // MARK: - CompositionalLayout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            
            if self.shouldShowShorts() {
                switch sectionIndex {
                case 0: return self.createFiltersSection()
                case 1: return self.createShortsSection()
                case 2: return self.createVideosSection()
                default: return nil
                }
            } else {
                switch sectionIndex {
                case 0: return self.createFiltersSection()
                case 1: return self.createVideosSection()
                default: return nil
                }
            }
        }
    }
    
    private func createFiltersSection() -> NSCollectionLayoutSection {
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        var items: [NSCollectionLayoutItem] = []
        
        for filterText in filters {
            let textSize = filterText.size(withAttributes: [.font: font])
            let itemWidth = ceil(textSize.width) + 24
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(40)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            items.append(item)
        }
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1000),
            heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: items)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    private func createShortsSection() -> NSCollectionLayoutSection? {
        guard shouldShowShorts() else { return nil }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(32)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createVideosSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(330)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(330)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        return section
    }
    
    // MARK: - Data Methods
    private func shouldShowShorts() -> Bool {
        return selectedFilterIndex == 0
    }
    
    private func getFilteredVideos() -> [Video] {
        if selectedFilterIndex == 0 {
            return MockData.videos.filter { $0.category != nil }
        }
        
        let selectedFilter = filters[selectedFilterIndex]
        guard let category = VideoCategory(rawValue: selectedFilter) else { return [] }
        return MockData.videos.filter { $0.category == category }
    }
    
    private func updateFilteredContent() {
        filteredVideos = getFilteredVideos()
        collectionView.reloadData()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(item: self.selectedFilterIndex, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    // MARK: - Button Actions
    @objc private func castButtonTapped() {
        print("Cast button tapped - открытие overlay Выберите устройство")
    }
    
    @objc private func notificationButtonTapped() {
        print("Notification button tapped - открытие уведомлений")
    }
    
    @objc private func searchButtonTapped() {
        print("Search button tapped - открытие поиска")
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shouldShowShorts() ? 3 : 2 // Filters, Shorts (if shown), Videos
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldShowShorts() {
            switch section {
            case 0: return filters.count
            case 1: return MockData.shortsVideos.count
            case 2: return filteredVideos.count
            default: return 0
            }
        } else {
            switch section {
            case 0: return filters.count
            case 1: return filteredVideos.count
            default: return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if shouldShowShorts() {
            switch indexPath.section {
            case 0: // Filters
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
                cell.configure(with: filters[indexPath.item])
                cell.isSelected = indexPath.item == selectedFilterIndex
                return cell
            case 1: // Shorts
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortsCell", for: indexPath) as! ShortsCell
                let video = MockData.shortsVideos[indexPath.item]
                cell.configure(with: video, at: indexPath.item)
                return cell
            case 2: // Videos
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
                let video = filteredVideos[indexPath.item]
                cell.configure(with: video)
                return cell
                
            default:
                return UICollectionViewCell()
            }
        } else {
            // When not showing Shorts
            switch indexPath.section {
            case 0: // Filters
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
                cell.configure(with: filters[indexPath.item])
                cell.isSelected = indexPath.item == selectedFilterIndex
                return cell
            case 1: // Videos
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
                let video = filteredVideos[indexPath.item]
                cell.configure(with: video)
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1 && shouldShowShorts() {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "ShortsHeader",
                for: indexPath
            ) as! ShortsHeaderView
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if shouldShowShorts() {
            // When showing Shorts: 0=Filters, 1=Shorts, 2=Videos
            switch indexPath.section {
            case 0:
                selectedFilterIndex = indexPath.item
                updateFilteredContent()
                print("Filter selected: \(filters[indexPath.item]) - showing \(filteredVideos.count) videos")
                
            case 1:
                let video = MockData.shortsVideos[indexPath.item]
                print("Shorts video tapped: \(video.title)")
                openShortsWithPush(startingAt: indexPath.item)
                
            case 2:
                let video = filteredVideos[indexPath.item]
                print("Video tapped: \(video.title)")
                
            default:
                break
            }
        } else {
            // When NOT showing shorts: 0=Filters, 1=Videos
            switch indexPath.section {
            case 0:
                selectedFilterIndex = indexPath.item
                updateFilteredContent()
                print("Filter selected: \(filters[indexPath.item]) - showing \(filteredVideos.count) videos")
                
            case 1:
                let video = filteredVideos[indexPath.item]
                print("Video tapped: \(video.title)")
                
            default:
                break
            }
        }
    }
    
    private func openShortsWithPush(startingAt index: Int) {
        let shortsVC = ShortsTabViewController()
        shortsVC.startingVideoIndex = index
        shortsVC.isFromHomeNavigation = true
        
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(shortsVC, animated: true)
    }
}
