import Foundation

public class LocalUseCase {
    let store: JokesCachedStore
    let currentDate: () -> Date
    
    public init(with store: JokesCachedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalUseCase: JokesLoader {
    private enum LocalJokesCachePolicy {        
        private static let calendar = Calendar(identifier: .gregorian)
        
        private static var maxCacheAgeInDays: Int {
            return 7
        }
        
        static func validate(_ cache: CachedFeed, with date: Date) -> Bool {
            guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: cache.timestamp) else {
                return false
            }
            
            return date < maxCacheAge
        }
    }
    
    public typealias LoadResult = JokesLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
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

private extension LocalJoke {
    var model: Joke {
        return Joke(with: self.id, joke: self.joke)
    }
}

public extension Array where Element == LocalJoke {
    var model: [Joke] {
        return self.map({$0.model})
    }
}

