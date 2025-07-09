import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var liked: Bool
    @NSManaged public var imageData: Data?

}

extension PostEntity : Identifiable {

}
