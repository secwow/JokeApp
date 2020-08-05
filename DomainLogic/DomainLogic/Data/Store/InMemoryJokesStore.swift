import Foundation

public final class InMemoryJokesStore: Store {
    private var jokes: [LocalJoke] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    public var onUpdate: (() -> ())?
    
    enum Error: Swift.Error {
        case deleteUnkownValue, updatingUnkownValue
    }
    
    public init() {}
    
    public func insert(_ joke: LocalJoke, completion: @escaping UpdationCompletion) {
        jokes.append(joke)
        completion(.success(()))
    }
    
    public func update(_ joke: LocalJoke, completion: @escaping UpdationCompletion) {
        guard let index = jokes.firstIndex(of: joke) else {
            completion(.failure(Error.updatingUnkownValue))
            return
        }
        
        jokes[index] = joke
        completion(.success(()))
    }
    
    public func delete(_ joke: LocalJoke, completion: @escaping UpdationCompletion) {
        guard let index = jokes.firstIndex(of: joke) else {
            completion(.success(()))
            return
        }
        
        jokes.remove(at: index)
        completion(.success(()))
    }

    public func getAll(completion: @escaping RetriveJokesCompletion) {
        completion(.success(jokes))
    }
}
