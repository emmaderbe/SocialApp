import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func savePosts(_ posts: [PostStruct])
    func fetchPosts() -> [PostDataModel]
    func updateLike(for id: Int, liked: Bool)
}

// MARK: - Properties and init()
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

// MARK: - CoreDataManagerProtocol functions
extension CoreDataManager {
    /// Сохраняет массив постов в Core Data
    /// Если пост с таким id уже существует, обновляет его поля. Иначе создаёт новый
    func savePosts(_ posts: [PostStruct]) {
        posts.forEach { post in
            let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", post.id)

            let entity = (try? context.fetch(fetchRequest).first) ?? PostEntity(context: context)

            entity.id = Int32(post.id)
            entity.title = post.title
            entity.body = post.body
            entity.liked = post.liked

            if let newImageData = post.image?.pngData() {
                entity.imageData = newImageData
            }
        }

        do {
            try context.save()
        } catch {
            print("❌ Save error: \(error)")
        }
    }

    /// Загружает все сохранённые посты из Core Data
    /// Возвращает массив PostDataModel для дальнейшего отображения
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

    /// Обновляет статус лайка у поста с указанным id
    func updateLike(for id: Int, liked: Bool) {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        if let entity = try? context.fetch(request).first {
            entity.liked = liked
            try? context.save()
        }
    }
}
