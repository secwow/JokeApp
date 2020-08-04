import DomainLogic

final class JokesLoaderCompositor: JokesLoader {
    private let primaryLoader: JokesLoader
    private let secondaryLoader: JokesLoader
    private let instructor: NetworkInstructor
    
    internal init(primaryLoader: JokesLoader, secondaryLoader: JokesLoader, instructor: NetworkInstructor) {
        self.primaryLoader = primaryLoader
        self.secondaryLoader = secondaryLoader
        self.instructor = instructor
    }
    
    func load(completion: @escaping (JokesLoader.Result) -> Void) {
        if self.instructor.isOffline {
            self.secondaryLoader.load(completion: completion)
        } else {
            primaryLoader.load { [weak self] result in
                switch result {
                case .success:
                    completion(result)
                case .failure:
                    self?.secondaryLoader.load(completion: completion)
                }
            }
        }
    }
}
