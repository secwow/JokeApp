import Foundation

public extension LocalJoke {
    convenience init(_ joke: Joke) {
        self.init(with: joke.id, joke: joke.joke)
    }
}

extension Array where Element == Joke {
    var local: [LocalJoke] {
        return self.map({ .init($0 )})
    }
}
