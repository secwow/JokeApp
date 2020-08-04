import DomainLogic

final class JokesListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let jokesLoader: JokesLoader
    private let networkInstructor: NetworkInstructor
    
    init(jokesLoader: JokesLoader, networkInstructor: NetworkInstructor) {
        self.jokesLoader = jokesLoader
        self.networkInstructor = networkInstructor
    }

    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[Joke]>?
    var onErrorAppeared: Observer<Bool>?
    
    private var cummulativeResult: [Joke] = []
    
    func loadFeed() {
        onLoadingStateChange?(true)
        onErrorAppeared?(false)
        jokesLoader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(feed):
                if self.networkInstructor.isOffline == false {
                    self.cummulativeResult.append(contentsOf: feed)
                    self.onFeedLoad?(self.cummulativeResult)
                } else {
                    self.onFeedLoad?(feed)
                }
            case .failure(_):
                self.onErrorAppeared?(true)
            }
            self.onLoadingStateChange?(false)
        }
    }
    
    func loadNext() {
        if self.networkInstructor.isOffline == false {
            loadFeed()
        }
    }
}
