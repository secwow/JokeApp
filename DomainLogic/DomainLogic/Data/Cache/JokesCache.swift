import Foundation

public protocol JokesCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ jokes: [Joke], completion: @escaping (Result) -> Void)
}

