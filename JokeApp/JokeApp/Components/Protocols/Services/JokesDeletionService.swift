import DomainLogic

protocol JokesDeletionService {
    func deleteJoke(_ joke: Joke, completion: @escaping (Result<Void, Error>) -> ())
}
