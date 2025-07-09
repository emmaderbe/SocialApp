import Foundation

protocol ImageURLProtocol {
    func url(for postID: Int) -> URL?
}

final class ImageURLBuilder: ImageURLProtocol {
    func url(for postID: Int) -> URL? {
            URL(string: "https://picsum.photos/seed/\(postID)/100")
        }
}
