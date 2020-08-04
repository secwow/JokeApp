import Foundation

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
