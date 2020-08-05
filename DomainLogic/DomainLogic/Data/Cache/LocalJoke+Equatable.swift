import Foundation

extension LocalJoke: Equatable {
    public static func == (lhs: LocalJoke, rhs: LocalJoke) -> Bool {
        return lhs.id == rhs.id
    }
}

