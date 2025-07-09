import CoreData

protocol CoreDataManagerProtocol {
    func savePosts(_ posts: [PostStruct])
    func fetchPosts() -> [PostDataModel]
    func updateLike(for id: Int, liked: Bool)
}

final class CoreDataManager: CoreDataManagerProtocol {
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    init() {
        container = NSPersistentContainer(name: "SocialApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
    }
}

extension CoreDataManager {
    func savePosts(_ posts: [PostStruct]) {
        posts.forEach { post in
            let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", post.id)

            if let existing = try? context.fetch(fetchRequest).first {
                existing.title = post.title
                existing.body = post.body
                existing.liked = post.liked
                existing.imageData = post.image?.pngData()
            } else {
                let entity = PostEntity(context: context)
                entity.id = Int32(post.id)
                entity.title = post.title
                entity.body = post.body
                entity.liked = post.liked
                entity.imageData = post.image?.pngData()
            }
        }

        do {
            try context.save()
        } catch {
            print("❌ Save error: \(error)")
        }
    }

    
    func fetchPosts() -> [PostDataModel] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        
        return result.map {
            PostDataModel(
                id: Int($0.id),
                imageData: $0.imageData,
                title: $0.title ?? "",
                body: $0.body ?? "",
                liked: $0.liked
            )
        }
    }
    
    func updateLike(for id: Int, liked: Bool) {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        if let entity = try? context.fetch(request).first {
            entity.liked = liked
            try? context.save()
        }
    }
}
