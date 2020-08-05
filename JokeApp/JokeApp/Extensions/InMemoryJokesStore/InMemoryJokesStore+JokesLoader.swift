import DomainLogic

extension InMemoryJokesStore: JokesLoader {
    public func load(completion: @escaping (JokesLoader.Result) -> Void) {
        self.getAll { (result) in
            switch result {
            case let .success(jokes):
                completion(.success(jokes.model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
