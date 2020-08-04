import Foundation

public protocol JokesStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias UpdationResult = Result<Void, Error>
    typealias UpdationCompletion = (InsertionResult) -> Void
    
    typealias RetriveJokesResult = Result<[LocalJoke], Error>
    typealias RetriveJokesCompletion = (RetriveJokesResult) -> Void

    func insert(_ joke: LocalJoke, completion: @escaping InsertionCompletion)
    func update(_ joke: LocalJoke, completion: @escaping UpdationCompletion)
    func delete(_ joke: LocalJoke, completion: @escaping DeletionCompletion)
    func getAll(completion: @escaping RetriveJokesCompletion)
}
