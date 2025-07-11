import Foundation
import UIKit

final class PostMapper {
    func map(from api: FeedResponse) -> PostStruct {
        return PostStruct(
            id: api.id,
            image: nil,
            title: api.title,
            body: api.body,
            liked: false,
        )
    }

    func map(from list: [FeedResponse]) -> [PostStruct] {
        return list.map { map(from: $0) }
    }
}

extension PostMapper {
    func map(from model: PostDataModel) -> PostStruct {
        let image: UIImage? = model.imageData.flatMap { UIImage(data: $0) }
        return PostStruct(
            id: model.id,
            image: image,
            title: model.title,
            body: model.body,
            liked: model.liked
        )
    }

    
    func update(post: PostStruct, withImageData data: Data?) -> PostStruct {
        guard let data = data, let image = UIImage(data: data) else { return post }
        return PostStruct(
            id: post.id,
            image: image,
            title: post.title,
            body: post.body,
            liked: post.liked
        )
    }
}
