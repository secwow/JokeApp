import DomainLogic
import XCTest

func makeUniqueJoke() -> LocalJoke {
    return LocalJoke(with: UUID().hashValue, joke: "Some joke")
}

func makeJokesFeed() -> (feed: [LocalJoke], timestamp: Date) {
    return ([LocalJoke(with: 1, joke: "Some joke"),
            LocalJoke(with: 2, joke: "Some joke2"),
            LocalJoke(with: 3, joke: "Some joke3")], Date())
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
