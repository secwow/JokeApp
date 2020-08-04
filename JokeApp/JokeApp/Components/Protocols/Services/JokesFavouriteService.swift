import DomainLogic

protocol JokesFavouriteService: AnyObject {
    func addToFavourite(_ joke: Joke)
}

