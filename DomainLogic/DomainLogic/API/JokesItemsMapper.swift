import Foundation

final class JokesItemsMapper {
    private struct Root: Decodable {
        let type: String
        let value: [RemoteJoke]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteJoke] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteJokesLoader.Error.invalidData
        }

        return root.value
    }
}
