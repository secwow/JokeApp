import Foundation

extension FavouriteJoke {
    var local: LocalJoke {
        return LocalJoke(with: id, joke: joke)
    }
}

extension FavouriteJoke: Equatable {
    public static func == (lhs: FavouriteJoke, rhs: FavouriteJoke) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Array where Element == FavouriteJoke {
    var local: [LocalJoke] {
        return self.map({$0.local})
    }
}
