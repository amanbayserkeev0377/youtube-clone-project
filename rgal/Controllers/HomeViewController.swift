import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private let customNavBar = UIView()
    private let logoImageView = UIImageView()
    private let castButton = UIButton()
    private let notificationButton = UIButton()
    private let searchButton = UIButton()
    private let mainScrollView = UIScrollView()
    private let contentView = UIView()
    
    private let filtersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    //MARK: - Filter data
    
    private let filters = ["All", "Gaming", "Music", "News", "Podcasts", "Tech", "Entertainment"]
    private var selectedFilterIndex = 0
    private var filteredVideos: [Video] = []
    private func shouldShowShorts() -> Bool {
        return selectedFilterIndex == 0
    }
    
    private func getFilteredVideos() -> [Video] {
        if selectedFilterIndex == 0 {
            return MockData.videos.filter { $0.category != nil }
        }
        
        let selectedFilter = filters[selectedFilterIndex]
        if selectedFilter == "Recently uploaded" {
            let dayAgo = Date().addingTimeInterval(-86400)
            return MockData.videos.filter { $0.category != nil && $0.uploadDate > dayAgo }
        }
        
        guard let category = VideoCategory(rawValue: selectedFilter) else { return [] }
        return MockData.videos.filter { $0.category == category }
    }
    
    private func updateFilteredContent() {
        filteredVideos = getFilteredVideos()
        UIView.transition(with: videosTableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.videosTableView.reloadData()
        }
        view.setNeedsLayout()
        shortsContainerView.isHidden = !shouldShowShorts()
    }
    
    
    private let shortsContainerView = UIView()
    private let shortsLabel = UILabel()
    private let shortsIcon = UIImageView()
    
    private let shortsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        
        return collectionView
    }()
    
    // Main videos section
    private let videosTableView = UITableView()
    
    // MARK: - Constants
    
    private struct Layout {
        static let navBarHeight: CGFloat = 44
        static let horizontalPadding: CGFloat = 16
        static let buttonSize: CGFloat = 24
        static let buttonSpacing: CGFloat = 16
        static let logoWidth: CGFloat = 92
        static let logoHeight: CGFloat = 28
        
        static let filtersHeight: CGFloat = 40
        static let filtersTopMargin: CGFloat = 8
        static let filtersBottomMargin: CGFloat = 16
        
        static let shortsIconSize: CGFloat = 24
        static let shortsHeaderHeight: CGFloat = 32
        static let shortsBottomMargin: CGFloat = 24
        
        static let videoRowHeight: CGFloat = 330
        static let bottomPadding: CGFloat = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        updateFilteredContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAllFrames()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupViews() {
        setupCustomNavBar()
        setupMainScrollView()
        setupFiltersCollectionView()
        setupShortsSection()
        setupVideosTableView()
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
    
    private func setupMainScrollView() {
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.alwaysBounceVertical = true
        view.addSubview(mainScrollView)
        
        contentView.backgroundColor = .systemBackground
        mainScrollView.addSubview(contentView)
    }
    
    private func setupFiltersCollectionView() {
        filtersCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        contentView.addSubview(filtersCollectionView)
        
        filtersCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }
    
    private func setupShortsSection() {
        contentView.addSubview(shortsContainerView)
        
        shortsIcon.image = UIImage(named: "youtube_shorts")
        shortsIcon.contentMode = .scaleAspectFit
        shortsContainerView.addSubview(shortsIcon)
        
        shortsLabel.text = "Shorts"
        shortsLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        shortsLabel.textColor = .label
        
        shortsContainerView.addSubview(shortsLabel)
        shortsContainerView.addSubview(shortsCollectionView)
        
        shortsCollectionView.register(ShortsCell.self, forCellWithReuseIdentifier: "ShortsCell")
        shortsCollectionView.delegate = self
        shortsCollectionView.dataSource = self
    }
    
    private func setupVideosTableView() {
        videosTableView.backgroundColor = .systemBackground
        videosTableView.separatorStyle = .none
        videosTableView.showsVerticalScrollIndicator = false
        videosTableView.isScrollEnabled = false
        videosTableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoCell")
        videosTableView.delegate = self
        videosTableView.dataSource = self
        
        contentView.addSubview(videosTableView)
    }
    
    private func setupAllFrames() {
        let safeAreaTop = view.safeAreaInsets.top
        let safeAreaBottom = view.safeAreaInsets.bottom
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        
        setupNavBarFrames(safeAreaTop: safeAreaTop, screenWidth: screenWidth)
        
        let scrollViewFrame = setupScrollViewFrames(
            navBarBottom: safeAreaTop + Layout.navBarHeight,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            safeAreaBottom: safeAreaBottom
        )
        
        setupContentFrames(scrollViewWidth: scrollViewFrame.width)
    }
    
    private func setupNavBarFrames(safeAreaTop: CGFloat, screenWidth: CGFloat) {
        
        customNavBar.frame = CGRect(
            x: 0,
            y: safeAreaTop,
            width: screenWidth,
            height: Layout.navBarHeight
        )
        
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
    }
    
    private func setupScrollViewFrames(navBarBottom: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat, safeAreaBottom: CGFloat) -> CGRect {
        let scrollViewFrame = CGRect(
            x: 0,
            y: navBarBottom,
            width: screenWidth,
            height: screenHeight - navBarBottom - safeAreaBottom
        )
        mainScrollView.frame = scrollViewFrame
        
        return scrollViewFrame
    }
    
    private func setupContentFrames(scrollViewWidth: CGFloat) {
        let filtersY: CGFloat = Layout.filtersTopMargin
        let filtersHeight = Layout.filtersHeight
        
        let shortsY = filtersY + filtersHeight + Layout.filtersBottomMargin
        let shortsHeight = shouldShowShorts() ? calculateShortsHeight(width: scrollViewWidth) : 0
        
        let videosY = shortsY + shortsHeight + Layout.shortsBottomMargin
        let videosHeight = CGFloat(filteredVideos.count) * Layout.videoRowHeight
        
        let totalContentHeight = videosY + videosHeight + Layout.bottomPadding
        
        contentView.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: totalContentHeight)
        mainScrollView.contentSize = CGSize(width: scrollViewWidth, height: totalContentHeight)
        
        setupFiltersFrames(y: filtersY, width: scrollViewWidth, height: filtersHeight)
        setupShortsFrames(y: shortsY, width: scrollViewWidth, height: shortsHeight)
        setupVideosFrames(y: videosY, width: scrollViewWidth, height: videosHeight)
    }
    
    private func setupFiltersFrames(y: CGFloat, width: CGFloat, height: CGFloat) {
        filtersCollectionView.frame = CGRect(
            x: Layout.horizontalPadding,
            y: y,
            width: width - (Layout.horizontalPadding * 2),
            height: height
        )
    }
    
    private func setupShortsFrames(y: CGFloat, width: CGFloat, height: CGFloat) {
        shortsContainerView.frame = CGRect(x: 0, y: y, width: width, height: height)
        
        shortsIcon.frame = CGRect(
            x: Layout.horizontalPadding,
            y: 0,
            width: Layout.shortsIconSize,
            height: Layout.shortsIconSize
        )
        
        let labelSize = shortsLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: Layout.shortsIconSize))
        shortsLabel.frame = CGRect(
            x: shortsIcon.frame.maxX + 8,
            y: (Layout.shortsIconSize - labelSize.height) / 2,
            width: labelSize.width,
            height: labelSize.height
        )
        
        shortsCollectionView.frame = CGRect(
            x: 12,
            y: Layout.shortsHeaderHeight,
            width: width - 24,
            height: height - Layout.shortsHeaderHeight - 8
        )
    }
    
    private func setupVideosFrames(y: CGFloat, width: CGFloat, height: CGFloat) {
        videosTableView.frame = CGRect(x: 0, y: y, width: width, height: height)
    }
    
    private func calculateShortsHeight(width: CGFloat) -> CGFloat {
        return Layout.shortsHeaderHeight + 240 + 16
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filtersCollectionView {
            return filters.count
        } else if collectionView == shortsCollectionView {
            return MockData.shortsVideos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filtersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
            cell.configure(with: filters[indexPath.item])
            cell.isSelected = indexPath.item == selectedFilterIndex
            return cell
        } else if collectionView == shortsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortsCell", for: indexPath) as! ShortsCell
            let video = MockData.shortsVideos[indexPath.item]
            cell.configure(with: video, at: indexPath.item)
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView {
            selectedFilterIndex = indexPath.item
            updateFilteredContent()
            print("Filter selected: \(filters[indexPath.item]) - showing \(filteredVideos.count) videos")
            
        } else if collectionView == shortsCollectionView {
            let video = MockData.shortsVideos[indexPath.item]
            print("Shorts video tapped: \(video.title)")
            print("Tapped shorts at index: \(indexPath.item)")

            openShortsWithPush(startingAt: indexPath.item)
        }
    }
    
    private func openShortsWithPush(startingAt index: Int) {
        let shortsVC = ShortsTabViewController()
        shortsVC.startingVideoIndex = index
        shortsVC.isFromHomeNavigation = true
        
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(shortsVC, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == filtersCollectionView {
            let filterText = filters[indexPath.item]
            let textSize = (filterText as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            return CGSize(width: textSize.width + 24, height: 40)
        } else if collectionView == shortsCollectionView {
            let itemWidth: CGFloat = 140
            let itemHeight: CGFloat = 240
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        return CGSize(width: 100, height: 40)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoTableViewCell
        let video = filteredVideos[indexPath.row]
        cell.configure(with: video)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let video = filteredVideos[indexPath.row]
        print("Video tapped: \(video.title)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Layout.videoRowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Layout.videoRowHeight
    }
}
