import Foundation

// MARK: - Protocol
protocol PaginationManagerProtocol {
    var canLoadNextPage: Bool { get }
    
    func beginLoading()
    func endLoading(receivedCount: Int)
    func requestParams() -> (start: Int, limit: Int)
    func reset()
}

// MARK: - Properties and init
final class PaginationManager: PaginationManagerProtocol {
    private var currentPage: Int = 0
    private var isLoading = false
    private var hasMore = true
    private let pageSize: Int
    
    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    var canLoadNextPage: Bool {
        return !isLoading && hasMore
    }
}

extension PaginationManager {
    func beginLoading() {
        isLoading = true
    }
    
    func endLoading(receivedCount: Int) {
        isLoading = false
        currentPage += 1
        hasMore = receivedCount == pageSize
    }
    
    func reset() {
        currentPage = 0
        isLoading = false
        hasMore = true
    }
    
    func requestParams() -> (start: Int, limit: Int) {
        return (start: currentPage * pageSize, limit: pageSize)
    }

}
