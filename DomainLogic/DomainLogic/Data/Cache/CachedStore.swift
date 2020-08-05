import Foundation

public typealias CachedFeed = (feed: [LocalJoke], timestamp: Date)

public protocol JokesCachedStore {
    
    typealias UpdateResult = Result<Void, Error>
    typealias UpdationCompletion = (UpdateResult) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    func deleteCachedFeed(completion: @escaping UpdationCompletion)
    
    func insert(_ feed: [LocalJoke], timestamp: Date, completion: @escaping UpdationCompletion)
    
    func retrieve(completion: @escaping RetrievalCompletion)
}
