import Foundation

extension LocalJoke: Equatable {
    public static func == (lhs: LocalJoke, rhs: LocalJoke) -> Bool {
        return lhs.id == rhs.id
    }
}

public extension LocalJoke {
    var favourite: FavouriteJoke {
        return FavouriteJoke(with: id, joke: joke)
    }
}

public extension LocalJoke {
    var model: Joke {
        return Joke(with: self.id, joke: self.joke)
    }
}

public extension Array where Element == LocalJoke {
    var model: [Joke] {
        return self.map({$0.model})
    }
}
