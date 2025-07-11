import UIKit

//MARK: - Properties and init
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
}

// MARK: - Public method
extension LikeButton {
    func configure(isLiked: Bool) {
        self.isLiked = isLiked
        updateAppearance()
    }
}

//MARK: - Private setup
private extension LikeButton {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        updateAppearance()
    }
    
    /// Метод вызывается при нажатии на кнопку
    /// Меняет состояние лайка, обновляет внешний вид, запускает анимацию и вибрацию
    @objc func tapped() {
        isLiked.toggle()
        updateAppearance()
        animateTap()
        vibrate()
        onTap?(isLiked)
    }
    
    /// Обновляет иконку и цвет кнопки в зависимости от состояния
    func updateAppearance() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageName = isLiked ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName, withConfiguration: config)
        setImage(image, for: .normal)
        tintColor = isLiked ? .systemRed : .systemGray
    }
    
    /// Добавляет анимацию «прыжка» при нажатии на кнопку
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
    
    /// Добавляет лёгкую вибрацию при взаимодействии с кнопкой
    func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
