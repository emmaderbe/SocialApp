import UIKit

// MARK: - Properties and init
final class FeedView: UIView {
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
        view.separatorStyle = .singleLine
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.showsVerticalScrollIndicator = false 
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

// MARK: - UI setup
private extension FeedView {
    func setupView() {
        backgroundColor = .white
        addSubview(tableView)
        tableView.refreshControl = refreshControl
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}

// MARK: - Collection setup
extension FeedView {
    func setDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func setDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadItems(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
}

// MARK: - Pull to refresh
extension FeedView {
    func setRefreshTarget(_ target: Any?, action: Selector) {
        refreshControl.addTarget(target, action: action, for: .valueChanged)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
