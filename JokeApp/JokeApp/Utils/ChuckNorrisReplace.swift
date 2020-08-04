import DomainLogic

class ChuckNorrisReplaceDecorator: JokesLoader {
    let decoratee: JokesLoader
    let service: ReplacingState
    
    init(decoratee: JokesLoader, service: ReplacingState) {
        self.decoratee = decoratee
        self.service = service
    }
    
    func load(completion: @escaping (JokesLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(jokes):
                if self.service.isOffline {
                    completion(.success(self.randomJokeWithReplacedName(jokes)))
                } else {
                    completion(.success(jokes))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func randomJokeWithReplacedName(_ jokes: [Joke]) -> [Joke] {
        let joke = jokes.map({Joke(with: $0.id,
                                   joke: $0.joke.replacingOccurrences(of: "Chuck Norris",
                                                                                    with: self.service.nameToReplace))})
                                                                                    .randomElement()
        if let joke = joke {
            return [joke]
        } else {
            return []
        }
    }
}
