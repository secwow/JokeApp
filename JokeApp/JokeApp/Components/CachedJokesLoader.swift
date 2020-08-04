import DomainLogic

public final class CachedJokesLoader: JokesLoader {
    private let decoratee: JokesLoader
    private let cache: JokesCache
    
    public init(decoratee: JokesLoader, cache: JokesCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (JokesLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.save(feed) { _ in }
                return feed
            })
        }
    }
}
