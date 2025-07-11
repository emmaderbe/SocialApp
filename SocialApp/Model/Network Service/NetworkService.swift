import Foundation
import Alamofire

enum APIConstants {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    static let posts = baseURL + "/posts"
}

// MARK: - Protocol
protocol NetworkServiceProtocol {
    func fetchPosts(start: Int, limit: Int, completion: @escaping (Result<[FeedResponse], Error>) -> Void)
}

// MARK: - Protocol function
final class NetworkService: NetworkServiceProtocol {
    
    func fetchPosts(start: Int, limit: Int, completion: @escaping (Result<[FeedResponse], Error>) -> Void) {
        
        let url = "\(APIConstants.posts)?_start=\(start)&_limit=\(limit)"
        
        AF.request(url).validate().responseDecodable(of: [FeedResponse].self) { response in
            switch response.result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

