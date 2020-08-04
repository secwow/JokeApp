import DomainLogic

class JokeCellViewModel {
    private let jokeModel: Joke
    private weak var favouriteService: JokesFavouriteService?
    private weak var shareDelegate: ShareDelegate?
    
    init(jokeModel: Joke, favouriteService: JokesFavouriteService, shareDelegate: ShareDelegate) {
        self.jokeModel = jokeModel
        self.favouriteService = favouriteService
        self.shareDelegate = shareDelegate
    }
  
    var joke: String {
        return jokeModel.joke
    }
    
    func share(_ joke: String) {
        shareDelegate?.share(joke)
    }
    
    func addToFavourite() {
        favouriteService?.addToFavourite(jokeModel)
    }
}
