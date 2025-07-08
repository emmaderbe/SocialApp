import Foundation
import Alamofire

enum APIConstants {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    static let posts = baseURL + "/posts"
}

protocol NetworkServiceProtocol {
    func fetchPosts(completion: @escaping (Result<[FeedResponse], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func fetchPosts(completion: @escaping (Result<[FeedResponse], Error>) -> Void) {
        
        let url = APIConstants.posts
        
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

