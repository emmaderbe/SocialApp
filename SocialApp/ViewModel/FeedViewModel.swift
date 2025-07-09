import Foundation
import CoreData

// MARK: - Loading State
enum LoadingState {
    case none
    case initial
    case refreshing
    case paginating
}

// MARK: - Protocol
protocol FeedViewModelProtocol {
    var onPostsUpdated: (([PostStruct]) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var onImageLoaded: ((Int, Data) -> Void)? { get set }
    var onLoadingStateChanged: ((LoadingState) -> Void)? { get set }
    
    func viewDidLoad()
    func refreshPosts()
    func loadNextPage()
    func updateLike(for id: Int, liked: Bool) 
}

// MARK: - Properties and init
final class FeedViewModel: FeedViewModelProtocol {
    private let networkService: NetworkServiceProtocol
    private let mapper: PostMapper
    private let pagination: PaginationManagerProtocol
    private let imageLoader: ImageLoaderProtocol
    private let imageBuilder: ImageURLProtocol
    private let coreData: CoreDataManagerProtocol
    private var posts: [PostStruct] = []
    
    var onLoadingStateChanged: ((LoadingState) -> Void)?
    var onImageLoaded: ((Int, Data) -> Void)?
    var onPostsUpdated: (([PostStruct]) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         mapper: PostMapper = PostMapper(),
         pagination: PaginationManagerProtocol = PaginationManager(pageSize: 5),
         imageLoader: ImageLoaderProtocol = ImageLoader(),
         imageBuilder: ImageURLProtocol = ImageURLBuilder(),
         coreData: CoreDataManagerProtocol = CoreDataManager()) {
        self.networkService = networkService
        self.mapper = mapper
        self.pagination = pagination
        self.imageLoader = imageLoader
        self.imageBuilder = imageBuilder
        self.coreData = coreData
    }
}

// MARK: - FeedViewModelProtocol functions
extension FeedViewModel {
    func viewDidLoad() {
        onLoadingStateChanged?(.initial)
        loadCachedPosts()
        fetchPosts(reset: true)
    }
    
    func refreshPosts() {
        pagination.reset()
        onLoadingStateChanged?(.refreshing)
        fetchPosts(reset: true)
    }
    
    func loadNextPage() {
        guard pagination.canLoadNextPage else { return }
        onLoadingStateChanged?(.paginating)
        fetchPosts(reset: false)
    }
    
    func updateLike(for id: Int, liked: Bool) {
        if let index = posts.firstIndex(where: { $0.id == id }) {
            posts[index].liked = liked
            coreData.updateLike(for: id, liked: liked)
        }
    }

}

// MARK: - Fetch data from API
private extension FeedViewModel {
    func fetchPosts(reset: Bool) {
        pagination.beginLoading()
        let (start, limit) = pagination.requestParams()
        
        networkService.fetchPosts(start: start, limit: limit) { [weak self] result in
            guard let self = self else { return }
            self.handleFetchResult(result, reset: reset)
        }
    }
    
    func handleFetchResult(_ result: Result<[FeedResponse], Error>, reset: Bool) {
        switch result {
        case .success(let response):
            processSuccess(response, reset: reset)
            
        case .failure(let error):
            pagination.reset()
            DispatchQueue.main.async {
                self.onError?(error)
                self.onLoadingStateChanged?(.none)
            }
        }
    }
    
    func processSuccess(_ response: [FeedResponse], reset: Bool) {
        let newPosts = mapper.map(from: response)
        pagination.endLoading(receivedCount: newPosts.count)
        posts = reset ? newPosts : posts + newPosts
        
        DispatchQueue.main.async {
            self.coreData.savePosts(newPosts)
            self.onPostsUpdated?(self.posts)
            self.onLoadingStateChanged?(.none)
            
            newPosts.forEach { self.loadImage(for: $0) }
        }
    }
    
    func loadImage(for post: PostStruct) {
        guard let url = imageBuilder.url(for: post.id) else { return }
        
        imageLoader.loadImage(from: url) { [weak self] data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.onImageLoaded?(post.id, data)
            }
        }
    }
}

private extension FeedViewModel {
    func loadCachedPosts() {
        let savedPosts = coreData.fetchPosts()
        
        let cachedPosts = savedPosts.map {
            PostStruct(
                id: $0.id,
                image: nil,
                title: $0.title,
                body: $0.body,
                liked: $0.liked
            )
        }
        
        self.posts = cachedPosts
        self.onPostsUpdated?(cachedPosts)
    }
}
