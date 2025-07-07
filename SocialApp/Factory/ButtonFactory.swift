import UIKit

final class LikeButton: UIButton {
    private var isLiked = false

    var onTap: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(isLiked: Bool) {
        self.isLiked = isLiked
        updateAppearance()
    }
}

private extension LikeButton {
    @objc func tapped() {
        isLiked.toggle()
        updateAppearance()
        onTap?(isLiked)
    }

    func updateAppearance() {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let imageName = isLiked ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName, withConfiguration: config)
        setImage(image, for: .normal)
        tintColor = isLiked ? .systemRed : .systemGray
    }
}
