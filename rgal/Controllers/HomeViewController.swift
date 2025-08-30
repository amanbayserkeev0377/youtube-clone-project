import UIKit

enum HomeSection: Int, CaseIterable {
    case filters
    case shorts
    case videos
}

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private let customNavigationBar = UIView()
    private let logoImageView = UIImageView()
    private let castButton = UIButton()
    private let notificationButton = UIButton()
    private let searchButton = UIButton()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = true
        
        // Optimize scrolling performance
        collectionView.isPrefetchingEnabled = true
        collectionView.remembersLastFocusedIndexPath = false
        
        return collectionView
    }()
    
    // MARK: - Data
    private let dataService: DataServiceProtocol = MockDataService.shared
    private var filters: [String] = []
    private var selectedFilterIndex = 0
    private var filteredVideos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupCollectionView()
        updateFilteredContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
    
    // MARK: - Data Loading
    private func loadData() {
        filters = dataService.getFilters()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        setupCustomNavigationBar()
        view.addSubview(collectionView)
    }
        
    private func setupCustomNavigationBar() {
        customNavigationBar.backgroundColor = .systemBackground
        view.addSubview(customNavigationBar)
        
        logoImageView.image = UIImage(named: "youtube_logo")
        logoImageView.contentMode = .scaleAspectFit
        customNavigationBar.addSubview(logoImageView)
        
        setupNavigationButtons()
    }
    
    private func setupNavigationButtons() {
        castButton.setImage(UIImage(systemName: "airplay.video"), for: .normal)
        castButton.tintColor = .label
        castButton.addTarget(self, action: #selector(castButtonTapped), for: .touchUpInside)
        customNavigationBar.addSubview(castButton)
        
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = .label
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        customNavigationBar.addSubview(notificationButton)
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .label
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        customNavigationBar.addSubview(searchButton)
    }
    
    private func setupCollectionView() {
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: CellIdentifier.filterCell)
        collectionView.register(ShortsCell.self, forCellWithReuseIdentifier: CellIdentifier.shortsCell)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: CellIdentifier.videoCell)
        
        collectionView.register(ShortsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryViewIdentifier.shortsHeader)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupFrames() {
        let safeAreaTop = view.safeAreaInsets.top
        let screenWidth = view.bounds.width
        
        customNavigationBar.frame = CGRect(
            x: 0,
            y: safeAreaTop,
            width: screenWidth,
            height: LayoutConstants.Home.navigationBarHeight
        )
        
        logoImageView.frame = CGRect(
            x: LayoutConstants.Home.horizontalPadding,
            y: (LayoutConstants.Home.navigationBarHeight - LayoutConstants.Home.logoHeight) / 2,
            width: LayoutConstants.Home.logoWidth,
            height: LayoutConstants.Home.logoHeight
        )
        
        searchButton.frame = CGRect(
            x: screenWidth - LayoutConstants.Home.horizontalPadding - LayoutConstants.Home.buttonSize,
            y: (LayoutConstants.Home.navigationBarHeight - LayoutConstants.Home.buttonSize) / 2,
            width: LayoutConstants.Home.buttonSize,
            height: LayoutConstants.Home.buttonSize
        )
        
        notificationButton.frame = CGRect(
            x: searchButton.frame.minX - LayoutConstants.Home.buttonSpacing - LayoutConstants.Home.buttonSize,
            y: (LayoutConstants.Home.navigationBarHeight - LayoutConstants.Home.buttonSize) / 2,
            width: LayoutConstants.Home.buttonSize,
            height: LayoutConstants.Home.buttonSize
        )
        
        castButton.frame = CGRect(
            x: notificationButton.frame.minX - LayoutConstants.Home.buttonSpacing - LayoutConstants.Home.buttonSize,
            y: (LayoutConstants.Home.navigationBarHeight - LayoutConstants.Home.buttonSize) / 2,
            width: LayoutConstants.Home.buttonSize,
            height: LayoutConstants.Home.buttonSize
        )
        
        collectionView.frame = CGRect(
            x: 0,
            y: safeAreaTop + LayoutConstants.Home.navigationBarHeight,
            width: screenWidth,
            height: view.bounds.height - safeAreaTop - LayoutConstants.Home.navigationBarHeight - view.safeAreaInsets.bottom
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
        var items: [NSCollectionLayoutItem] = []
        
        for filterText in filters {
            let textSize = filterText.size(withAttributes: [.font: FontConstants.filterCellFont])
            let itemWidth = ceil(textSize.width) + CollectionLayoutConstants.Filters.extraPadding
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(CollectionLayoutConstants.Filters.height)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            items.append(item)
        }
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(CollectionLayoutConstants.Filters.estimatedWidth),
            heightDimension: .absolute(CollectionLayoutConstants.Filters.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: items)
        group.interItemSpacing = .fixed(CollectionLayoutConstants.Filters.itemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = CollectionLayoutConstants.Filters.contentInsets
        
        return section
    }
    
    private func createShortsSection() -> NSCollectionLayoutSection? {
        guard shouldShowShorts() else { return nil }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(CollectionLayoutConstants.Shorts.itemWidth),
            heightDimension: .absolute(CollectionLayoutConstants.Shorts.itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(CollectionLayoutConstants.Shorts.itemWidth),
            heightDimension: .absolute(CollectionLayoutConstants.Shorts.itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = CollectionLayoutConstants.Shorts.interGroupSpacing
        section.contentInsets = CollectionLayoutConstants.Shorts.contentInsets
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(CollectionLayoutConstants.Shorts.headerHeight)
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
            heightDimension: .absolute(CollectionLayoutConstants.Videos.itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(CollectionLayoutConstants.Videos.itemHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = CollectionLayoutConstants.Videos.contentInsets
        
        return section
    }
    
    // MARK: - Data Methods
    private func shouldShowShorts() -> Bool {
        return selectedFilterIndex == 0
    }
    
    private func getFilteredVideos() -> [Video] {
        let videos = dataService.getVideos()
        
        if selectedFilterIndex == 0 {
            return videos.filter { $0.category != nil }
        }
        
        let selectedFilter = filters[selectedFilterIndex]
        guard let category = VideoCategory(rawValue: selectedFilter) else { return [] }
        return videos.filter { $0.category == category }
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
            case 1: return dataService.getShortsVideos().count
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.filterCell, for: indexPath) as! FilterCell
                cell.configure(with: filters[indexPath.item])
                cell.isSelected = indexPath.item == selectedFilterIndex
                return cell
            case 1: // Shorts
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.shortsCell, for: indexPath) as! ShortsCell
                let video = dataService.getShortsVideos()[indexPath.item]
                cell.configure(with: video, at: indexPath.item)
                return cell
            case 2: // Videos
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.videoCell, for: indexPath) as! VideoCell
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.filterCell, for: indexPath) as! FilterCell
                cell.configure(with: filters[indexPath.item])
                cell.isSelected = indexPath.item == selectedFilterIndex
                return cell
            case 1: // Videos
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.videoCell, for: indexPath) as! VideoCell
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
                withReuseIdentifier: SupplementaryViewIdentifier.shortsHeader,
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
                let video = dataService.getShortsVideos()[indexPath.item]
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
        print("Opening Shorts with index: \(index)")
        let shortsVC = ShortsTabViewController()
        shortsVC.startingVideoIndex = index
        shortsVC.isFromHomeNavigation = true
        
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(shortsVC, animated: true)
    }
}
