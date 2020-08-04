import DomainLogic

final class MyJokesListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let jokesLoader: JokesLoader
    
    init(jokesLoader: JokesLoader) {
        self.jokesLoader = jokesLoader
    }
    
    var onFeedLoad: Observer<[Joke]>?
    
    func loadFeed() {
        jokesLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onFeedLoad?(feed)
            default:
                break
            }
        }
    }
}
