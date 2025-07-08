import UIKit

final class LikeButton: UIButton {
    private var isLiked = false
    
    var onTap: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isLiked: Bool) {
        self.isLiked = isLiked
        updateAppearance()
    }
}

private extension LikeButton {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        updateAppearance()
    }
    
    @objc func tapped() {
        isLiked.toggle()
        updateAppearance()
        animateTap()
        vibrate()
        onTap?(isLiked)
    }
    
    func updateAppearance() {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let imageName = isLiked ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName, withConfiguration: config)
        setImage(image, for: .normal)
        tintColor = isLiked ? .systemRed : .systemGray
    }
    
    func animateTap() {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        })
    }
    
    func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
