import UIKit

// MARK: - Properties and init
final class FeedViewController: UIViewController {
    private let feedView = FeedView()
    private let dataSource = FeedTableViewDataSource()
    private let delegate = FeedTableViewDelegate()
    private var viewModel: FeedViewModelProtocol?
    
    init(viewModel: FeedViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC lifecycle
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel?.viewDidLoad()
        firstLoading()
        setupCollection()
    }
}


// MARK: - UI setup
private extension FeedViewController {
    func setupCollection() {
        feedView.setDataSource(dataSource)
        feedView.setDelegate(delegate)
        setupPagination()
        setupPullToRefresh()
        setupLike()
    }
    
    func setupLike() {
        dataSource.setLikeCallback { [weak self] postId, isLiked in
            self?.viewModel?.updateLike(for: postId, liked: isLiked)
        }
    }
}

// MARK: - Bindings
private extension FeedViewController {
    func bindViewModel() {
        viewModel?.onLoadingStateChanged = { [weak self] state in
            switch state {
            case .initial, .refreshing, .paginating:
                self?.dataSource.setSkeletonMode(true)
            case .none:
                self?.dataSource.setSkeletonMode(false)
            }
            self?.feedView.reloadData()
        }
        
        viewModel?.onPostsUpdated = { [weak self] posts in
            self?.dataSource.updatePosts(posts)
            
            posts.forEach { post in
                if let image = post.image {
                    self?.dataSource.setImage(image, for: post.id)
                }
            }
            self?.feedView.reloadData()
            self?.feedView.endRefreshing()
        }
        
        viewModel?.onError = { [weak self] error in
            self?.showErrorAlert()
            self?.feedView.endRefreshing()
        }
        
        viewModel?.onImageLoaded = { [weak self] postID, data in
            guard let self = self,
                  let image = UIImage(data: data),
                  let index = self.dataSource.indexOfPost(with: postID)
            else { return }

            self.dataSource.setImage(image, for: postID)
            let indexPath = IndexPath(item: index, section: 0)
            self.feedView.reloadItems(at: [indexPath])
        }
    }
}


// MARK: - Pagination
private extension FeedViewController {
    /// Настройка коллбэка, срабатывающего при прокрутке до конца списка
    func setupPagination() {
        delegate.onScrolledToBottom = { [weak self] in
            self?.viewModel?.loadNextPage()
        }
    }
}

// MARK: - Pull to refresh
private extension FeedViewController {
    func setupPullToRefresh() {
        feedView.setRefreshTarget(self, action: #selector(refreshPulled))
    }
    
    @objc func refreshPulled() {
        viewModel?.refreshPosts()
    }
}

// MARK: - UI helpers
private extension FeedViewController {
    /// Включает режим скелетон-загрузки при первом появлении экрана
    func firstLoading() {
        dataSource.setSkeletonMode(true)
        feedView.reloadData()
    }
    
    /// Показывает алерт пользователю об ошибке подключения
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Упс!",
            message: "Нет сети. Попробуйте ещё раз.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

}
