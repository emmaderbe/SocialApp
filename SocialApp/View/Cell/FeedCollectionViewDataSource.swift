import UIKit

final class FeedCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var posts: [PostStruct] = []
    
    func updatePosts(_ posts: [PostStruct]) {
        self.posts = posts
    }
}

extension FeedCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier,
                                                            for: indexPath) as? FeedCell else
        { return UICollectionViewCell() }
        let post = posts[indexPath.item]
        cell.configure(with: post)
        return cell
    }
}
