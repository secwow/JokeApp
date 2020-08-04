import DomainLogic

final class MyJokesListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let jokesLoader: JokesLoader
    
    init(jokesLoader: JokesLoader) {
        self.jokesLoader = jokesLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[Joke]>?
    var onErrorAppeared: Observer<Bool>?
    
    func loadFeed() {
        onLoadingStateChange?(true)
        onErrorAppeared?(false)
        jokesLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onFeedLoad?(feed)
            case .failure(_):
                self?.onErrorAppeared?(true)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
