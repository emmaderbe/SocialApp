import UIKit

final class FeedCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
}

extension FeedCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let width = collectionView.bounds.width - (insets.left + insets.right)
        return CGSize(width: width, height: 200)
    }
}
