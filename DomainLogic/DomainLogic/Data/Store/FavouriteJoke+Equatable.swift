import Foundation

extension FavouriteJoke: Equatable {
    public static func == (lhs: FavouriteJoke, rhs: FavouriteJoke) -> Bool {
        return lhs.id == rhs.id
    }
}
