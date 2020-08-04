import Foundation

public final class InMemoryJokesStore: JokesStore {
    private var jokes: [FavouriteJoke] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    public var onUpdate: (() -> ())?
    
    enum Error: Swift.Error {
        case deleteUnkownValue, updatingUnkownValue
    }
    
    public init() {}
    
    public func insert(_ joke: LocalJoke, completion: @escaping InsertionCompletion) {
        jokes.append(joke.favourite)
        completion(.success(()))
    }
    
    public func update(_ joke: LocalJoke, completion: @escaping UpdationCompletion) {
        guard let index = jokes.firstIndex(of: joke.favourite) else {
            completion(.failure(Error.updatingUnkownValue))
            return
        }
        
        jokes[index] = joke.favourite
        completion(.success(()))
    }
    
    public func delete(_ joke: LocalJoke, completion: @escaping DeletionCompletion) {
        guard let index = jokes.firstIndex(of: joke.favourite) else {
            completion(.success(()))
            return
        }
        
        jokes.remove(at: index)
        completion(.success(()))
    }

    public func getAll(completion: @escaping RetriveJokesCompletion) {
        completion(.success(jokes.local))
    }
}

private extension Array where Element == FavouriteJoke {
    var local: [LocalJoke] {
        return self.map({$0.local})
    }
}

private extension FavouriteJoke {
    var local: LocalJoke {
        return LocalJoke(with: id, joke: joke)
    }
}
