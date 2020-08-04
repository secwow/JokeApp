import DomainLogic

class ServiceFactory {
    private lazy var cache = InMemoryCachedJokesStore()
    private (set) lazy var storage = InMemoryJokesStore()
    private (set) lazy var reaplacingInstructor = ReplacingInstructor()
    private (set) lazy var localLoader = makeLocalLoader()
    private lazy var remoteLoader = makeRemoteLoader()
    private (set) lazy var mainLoader = makeMainLoader()
    
    func makeLocalLoader() -> LocalJokesLoader {
        return LocalJokesLoader(with: cache, currentDate: Date.init)
    }
    
    func makeRemoteLoader() -> JokesLoader {
        let client = SessionHTTPClient(session: URLSession.shared)
        let remoteJokesLoader = RemoteJokesLoader(url: URL(string: "http://api.icndb.com/jokes/random/10")!,
                                                  client: client)
        return remoteJokesLoader
    }
    
    func makeMainLoader() -> JokesLoader {
        let replacer = OfflineNameReplacerDecorator(decoratee: localLoader,
                                                   service: reaplacingInstructor)
        
        let mainLoader = JokesLoaderCompositor(primaryLoader: CachedJokesLoader(decoratee: remoteLoader,
                                                                                cache: localLoader),
                                               secondaryLoader: replacer,
                                               instructor: reaplacingInstructor)
        return mainLoader
    }
}
