import UIKit

class ShortsTabViewController: UIViewController {
    
    // MARK: - Properties
    var startingVideoIndex: Int = 0
    var isFromHomeNavigation: Bool = false
    private var hasScrolledToInitialVideo = false
    
    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
        if !hasScrolledToInitialVideo && startingVideoIndex >= 0 {
            let indexPath = IndexPath(item: startingVideoIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            hasScrolledToInitialVideo = true
        }
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
        collectionView.register(ShortsPlayerCell.self, forCellWithReuseIdentifier: "ShortsPlayerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
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
        return MockData.shortsVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortsPlayerCell", for: indexPath) as! ShortsPlayerCell
        let video = MockData.shortsVideos[indexPath.item]
        cell.configure(with: video, at: indexPath.item)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ShortsTabViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}
