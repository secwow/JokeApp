import DomainLogic

final class JokesListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let jokesLoader: JokesLoader
    private let networkInstructor: NetworkInstructor
    
    init(jokesLoader: JokesLoader, networkInstructor: NetworkInstructor) {
        self.jokesLoader = jokesLoader
        self.networkInstructor = networkInstructor
    }

    var onFeedLoad: Observer<[Joke]>?
    
    private var cummulativeResult: [Joke] = []
    
    func loadFeed() {
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
            default:
                break
            }
        }
    }
    
    func updateFeed() {
        if self.networkInstructor.isOffline == false {
            self.cummulativeResult = []
            loadFeed()
        } else {
            loadFeed()
        }
    }
    
    func loadNext() {
        if self.networkInstructor.isOffline == false {
            loadFeed()
        }
    }
}
