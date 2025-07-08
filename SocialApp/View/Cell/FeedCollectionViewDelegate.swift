import UIKit

// MARK: - Properties
final class FeedCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    var onScrolledToBottom: (() -> Void)?
}

// MARK: - Pagination helper
extension FeedCollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 {
            onScrolledToBottom?()
        }
    }
}

// MARK: - Cell size
extension FeedCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let width = collectionView.bounds.width - (insets.left + insets.right)
        return CGSize(width: width, height: 200)
    }
}
