import Foundation

public protocol JokesLoader {
    typealias Result = Swift.Result<[Joke], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
