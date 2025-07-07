import UIKit

final class FeedView: UIView {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FeedView {
    func setupView() {
        backgroundColor = .systemGray
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}

extension FeedView {
    func setDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func setDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}
