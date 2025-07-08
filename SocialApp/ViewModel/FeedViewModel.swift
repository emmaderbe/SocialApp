import Foundation

protocol FeedViewModelProtocol {
    var onPostsUpdated: (([PostStruct]) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func viewDidLoad()
    func refreshPosts()
}

final class FeedViewModel: FeedViewModelProtocol {
    private let networkService: NetworkServiceProtocol
    private let mapper: PostMapper
    private var posts: [PostStruct] = []
    
    var onPostsUpdated: (([PostStruct]) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService(), mapper: PostMapper = PostMapper()) {
        self.networkService = networkService
        self.mapper = mapper
    }
}

extension FeedViewModel {
    func viewDidLoad() {
        fetchPosts()
    }
    
    func refreshPosts() {
        fetchPosts()
    }
}

private extension FeedViewModel {
    func fetchPosts() {
        networkService.fetchPosts { [weak self] result in
            switch result {
            case .success(let feedResponses):
                let posts = self?.mapper.map(from: feedResponses) ?? []
                DispatchQueue.main.async {
                    self?.onPostsUpdated?(posts)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error)
                }
            }
        }
    }
}
