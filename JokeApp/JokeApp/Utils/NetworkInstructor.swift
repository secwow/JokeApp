import Foundation

protocol NetworkInstructor {
    var isOffline: Bool { get }
}

protocol ReplacingState: NetworkInstructor {
    var nameToReplace: String { get }
}

extension ReplacingInstructor: ReplacingState {}
