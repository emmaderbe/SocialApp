import UIKit

class FeedViewController: UIViewController {
    private let feedView = FeedView()
    private let dataSource = FeedCollectionViewDataSource()
    private let delegate = FeedCollectionViewDelegate()
    private var viewModel: FeedViewModelProtocol?
    
    init(viewModel: FeedViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        setupCollection()
        bindViewModel()
    }
}

private extension FeedViewController {
    func setupCollection() {
        feedView.setDataSource(dataSource)
        feedView.setDelegate(delegate)
    }
    
    func bindViewModel() {
        viewModel?.onPostsUpdated = { [weak self] posts in
            self?.dataSource.updatePosts(posts)
            self?.feedView.reloadData()
        }
        
        viewModel?.onError = { error in
            print("Ошибка: \(error.localizedDescription)")
        }
    }
}
