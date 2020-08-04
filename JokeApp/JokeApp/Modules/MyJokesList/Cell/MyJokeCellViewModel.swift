import DomainLogic
import UIKit

class MyJokeCellViewModel {
    private let jokeModel: Joke
    private let favouriteService: JokesDeletionService
    
    init(jokeModel: Joke, favouriteService: JokesDeletionService) {
        self.jokeModel = jokeModel
        self.favouriteService = favouriteService
    }
    
    var joke: String {
        return jokeModel.joke
    }
    
    var onDelete: (() -> ())?
    
    func delete() {
        favouriteService.deleteJoke(jokeModel) { [weak self] _ in
            self?.onDelete?()
        }
    }
}
