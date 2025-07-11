import UIKit

// MARK: - Properties
final class FeedTableViewDelegate: NSObject, UITableViewDelegate {
    var onScrolledToBottom: (() -> Void)?
}

// MARK: - Pagination helper
extension FeedTableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 {
            onScrolledToBottom?()
        }
    }
}
