import Foundation

public final class InMemoryCachedJokesStore: JokesCachedStore {
    private var cache: (feed: [LocalJoke], timestamp: Date)?
    
    public init() {}
    
    public func deleteCachedFeed(completion: @escaping UpdationCompletion) {
        cache = nil
        completion(.success(()))
    }
    
    public func insert(_ feed: [LocalJoke], timestamp: Date, completion: @escaping UpdationCompletion) {
        cache = (feed, timestamp)
        completion(.success(()))
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(cache))
    }
}
