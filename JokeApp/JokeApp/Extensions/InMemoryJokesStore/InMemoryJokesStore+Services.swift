import DomainLogic

extension InMemoryJokesStore: JokesFavouriteService {
    func addToFavourite(_ joke: Joke) {
        self.insert(.init(joke)) { _  in }
    }
}

extension InMemoryJokesStore: JokesDeletionService {
    func deleteJoke(_ joke: Joke, completion: @escaping (Result<Void, Error>) -> ()) {
        self.delete(.init(joke), completion: completion)
    }
}

extension InMemoryJokesStore: JokesSavingService {
    func save(_ joke: String) {
        self.insert(LocalJoke(with: UUID().hashValue, joke: joke)) { _ in }
    }
}

