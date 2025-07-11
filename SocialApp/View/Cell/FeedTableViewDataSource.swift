import UIKit

// MARK: - Properties
final class FeedTableViewDataSource: NSObject, UITableViewDataSource  {
    private var isSkeletonMode = false
    private var posts: [PostStruct] = []
    private var imageCache: [Int: UIImage] = [:]
    private var onLikeTapped: ((Int, Bool) -> Void)?
}

// MARK: - Reload data
extension FeedTableViewDataSource {
    func updatePosts(_ posts: [PostStruct]) {
        self.posts = posts
    }
    
    func setLikeCallback(_ callback: @escaping (Int, Bool) -> Void) {
        self.onLikeTapped = callback
    }
}

// MARK: - Reload image
extension FeedTableViewDataSource {
    func setImage(_ image: UIImage, for id: Int) {
        imageCache[id] = image
    }
    
    func indexOfPost(with id: Int) -> Int? {
        posts.firstIndex(where: { $0.id == id })
    }
}

// MARK: - Skeleton
extension FeedTableViewDataSource {
    func setSkeletonMode(_ enabled: Bool) {
        isSkeletonMode = enabled
    }
}

// MARK: - Collection setup
extension FeedTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSkeletonMode ? posts.count + 5 : posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier,
                                                       for: indexPath) as? FeedCell else
        { return UITableViewCell() }
        if indexPath.item >= posts.count {
            cell.showSkeleton()
            return cell
        }
        
        let post = posts[indexPath.item]
        cell.configure(with: post)
        
        if let image = imageCache[post.id] {
            cell.setImage(image)
        } else {
            cell.setImage(nil)
        }
        
        cell.setLikeAction { [weak self] isLiked in
            self?.onLikeTapped?(post.id, isLiked)
        }
        
        return cell
    }
}
