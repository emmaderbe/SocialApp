import UIKit

class FeedViewController: UIViewController {
    private let feedView = FeedView()
    private let dataSource = FeedCollectionViewDataSource()
    private let delegate = FeedCollectionViewDelegate()
    
    override func loadView() {
        view = feedView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        loadMockData()
    }
}

private extension FeedViewController {
    func setupCollection() {
        feedView.setDataSource(dataSource)
        feedView.setDelegate(delegate)
    }
}

extension FeedViewController {
    private func loadMockData() {
        let posts: [Post] = (1...10).map { index in
            Post(
                id: index,
                image: UIImage(named: "icon") ?? UIImage(systemName: "person.circle")!,
                title: "Пост \(index)",
                body: "Текст поста номер \(index). Здесь может быть длинный текст для проверки.",
                liked: false
            )
        }
        dataSource.updatePosts(posts)
        feedView.reloadData()
    }
}
