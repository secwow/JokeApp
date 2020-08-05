import Foundation

public struct Joke: Hashable {
    public let id: Int
    public let joke: String
    
    public init(with id: Int, joke: String) {
        self.id = id
        self.joke = joke
    }
}
