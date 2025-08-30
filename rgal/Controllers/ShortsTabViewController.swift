import UIKit

class ShortsTabViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    var startingVideoIndex: Int = 0
    var isFromHomeNavigation: Bool = false
    private let dataService: DataServiceProtocol = MockDataService.shared
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()

        if startingVideoIndex > 0 && startingVideoIndex < dataService.getShortsVideos().count {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let indexPath = IndexPath(item: self.startingVideoIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isFromHomeNavigation {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    // MARK: - CompositionalLayout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            
            return section
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if !isFromHomeNavigation {
            navigationItem.hidesBackButton = true
        }
        addRightBarButtons()
    }
    
    private func addRightBarButtons() {
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
        
        let moreButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(moreButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
    }
    
    private func setupCollectionView() {
        collectionView.register(ShortsPlayerCell.self, forCellWithReuseIdentifier: CellIdentifier.shortsPlayerCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
    }
    
    @objc private func searchButtonTapped() {
        print("Search button tapped in Shorts")
    }
    
    @objc private func moreButtonTapped() {
        print("More button tapped in Shorts")
    }
}

// MARK: - UICollectionViewDataSource
extension ShortsTabViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataService.getShortsVideos().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.shortsPlayerCell, for: indexPath) as! ShortsPlayerCell
        let video = dataService.getShortsVideos()[indexPath.item]
        cell.configure(with: video, at: indexPath.item)
        return cell
    }
}
