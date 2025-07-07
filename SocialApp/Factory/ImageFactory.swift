import UIKit

final class ImageFactory {
    static func createProfileImage() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "icon")
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
}
