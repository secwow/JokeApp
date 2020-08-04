import DomainLogic

final class MainQueueDispatchDecorator<T> {
    private let object: T
    
    init(_ object: T) {
        self.object = object
    }
    
    func dispatch(completion: @escaping () -> Void) {
        DispatchQueue.main.async(execute: completion)
    }
}

extension MainQueueDispatchDecorator: JokesLoader where T == JokesLoader {
    func load(completion: @escaping (JokesLoader.Result) -> Void) {
        self.object.load { [weak self] (result) in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
