import Foundation

public protocol JokesStore {
    
    typealias VoidErrorResult = Result<Void, Error>
    typealias DeletionResult = VoidErrorResult
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = VoidErrorResult
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias UpdationResult = VoidErrorResult
    typealias UpdationCompletion = (InsertionResult) -> Void
    
    typealias RetriveJokesResult = Result<[LocalJoke], Error>
    typealias RetriveJokesCompletion = (RetriveJokesResult) -> Void

    func insert(_ joke: LocalJoke, completion: @escaping InsertionCompletion)
    func update(_ joke: LocalJoke, completion: @escaping UpdationCompletion)
    func delete(_ joke: LocalJoke, completion: @escaping DeletionCompletion)
    func getAll(completion: @escaping RetriveJokesCompletion)
}
