import UIKit

// MARK: - Properties and init
final class FeedCell: UICollectionViewCell {
    private let avatarImageView = ImageFactory.createProfileImage()
    private let titleLabel = LabelFactory.createTitleLabel()
    private let bodyLabel = LabelFactory.createOrdinaryLabel()
    private let likeButton = LikeButton()
    
    private var isSkeleton = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI setup
private extension FeedCell {
    func setupCell() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .white
        [avatarImageView, titleLabel, bodyLabel, likeButton].forEach { addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            likeButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
        ])
    }
}

// MARK: - Skeleton
extension FeedCell {
    func showSkeleton() {
        isSkeleton = true
        titleLabel.text = " "
        bodyLabel.text = " "
        avatarImageView.image = nil
        likeButton.isHidden = true
        
        [titleLabel, bodyLabel].forEach {
            $0.backgroundColor = UIColor.systemGray5
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1
            animation.toValue = 0.5
            animation.duration = 0.8
            animation.autoreverses = true
            animation.repeatCount = .infinity
            $0.layer.add(animation, forKey: "skeleton")
        }
    }
    
    func hideSkeleton() {
        guard isSkeleton else { return }
        isSkeleton = false
        [titleLabel, bodyLabel].forEach {
            $0.layer.removeAllAnimations()
            $0.backgroundColor = .clear
        }
        likeButton.isHidden = false
    }
}

// MARK: - UI configure
extension FeedCell {
    func configure(with post: PostStruct) {
        hideSkeleton()
        titleLabel.text = post.title
        bodyLabel.text = post.body
        avatarImageView.image = post.image
        likeButton.configure(isLiked: post.liked)
    }
}

extension FeedCell {
    static var identifier: String {
        String(describing: FeedCell.self)
    }
}
