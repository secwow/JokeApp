import Foundation

public protocol Store {
    associatedtype Item: Equatable
    
    typealias UpdationResult = Result<Void, Error>
    typealias UpdationCompletion = (UpdationResult) -> Void
    
    typealias RetriveJokesResult = Result<[Item], Error>
    typealias RetriveJokesCompletion = (RetriveJokesResult) -> Void

    func insert(_ item: Item, completion: @escaping UpdationCompletion)
    func update(_ item: Item, completion: @escaping UpdationCompletion)
    func delete(_ item: Item, completion: @escaping UpdationCompletion)
    func getAll(completion: @escaping RetriveJokesCompletion)
}
