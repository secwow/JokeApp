import Foundation

public class LocalJokesLoader {
    let store: JokesCachedStore
    let currentDate: () -> Date
    
    public init(with store: JokesCachedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalJokesLoader: JokesLoader {
    private class LocalJokesCachePolicy {
        private init() {}
        
        private static let calendar = Calendar(identifier: .gregorian)
        
        private static var maxCacheAgeInDays: Int {
            return 7
        }
        
        static func validate(_ cache: (CachedFeed), with date: Date) -> Bool {
            guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: cache.timestamp) else {
                return false
            }
            
            return date < maxCacheAge
        }
    }
    
    public typealias LoadResult = JokesLoader.Result
    
    public func load(completion: @escaping (JokesLoader.Result) -> Void) {
          store.retrieve { [weak self] (result) in
              guard let self = self else { return }
              
              switch result {
              case let .failure(error):
                  completion(.failure(error))
              case let .success(.some(jokes)) where LocalJokesCachePolicy.validate(jokes, with: self.currentDate()):
                  completion(.success(jokes.feed.model))
              case .success:
                  completion(.success([]))
              }
          }
      }
}

extension LocalJokesLoader: JokesCache {
    public typealias SaveResult = JokesCache.Result

      public func save(_ jokes: [Joke], completion: @escaping (SaveResult) -> Void) {
          store.deleteCachedFeed { [weak self] deletionResult in
              guard let self = self else { return }
              
              switch deletionResult {
              case .success:
                  self.cache(jokes, with: completion)
              
              case let .failure(error):
                  completion(.failure(error))
              }
          }
      }
      
      private func cache(_ feed: [Joke], with completion: @escaping (SaveResult) -> Void) {
          store.insert(feed.local, timestamp: currentDate()) { [weak self] insertionResult in
              guard self != nil else { return }
              
              completion(insertionResult)
          }
      }
}
