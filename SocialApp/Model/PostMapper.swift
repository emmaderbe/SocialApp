import Foundation

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
