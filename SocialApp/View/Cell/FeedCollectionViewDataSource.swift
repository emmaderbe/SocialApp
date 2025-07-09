import UIKit

// MARK: - Properties
final class FeedCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var isSkeletonMode = false
    private var posts: [PostStruct] = []
    private var imageCache: [Int: UIImage] = [:]
}

// MARK: - Reload data
extension FeedCollectionViewDataSource {
    func updatePosts(_ posts: [PostStruct]) {
        self.posts = posts
    }
}

extension FeedCollectionViewDataSource {
    func setImage(_ image: UIImage, for id: Int) {
        imageCache[id] = image
    }
    
    func indexOfPost(with id: Int) -> Int? {
        posts.firstIndex(where: { $0.id == id })
    }
}

// MARK: - Skeleton
extension FeedCollectionViewDataSource {
    func setSkeletonMode(_ enabled: Bool) {
        isSkeletonMode = enabled
    }
}

// MARK: - Collection setup
extension FeedCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSkeletonMode ? posts.count + 5 : posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier,
                                                            for: indexPath) as? FeedCell else
        { return UICollectionViewCell() }
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
        return cell
    }
}
