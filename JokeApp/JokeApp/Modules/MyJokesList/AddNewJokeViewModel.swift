import Foundation

class AddNewJokeViewModel {
    let service: JokesSavingService
    
    init(service: JokesSavingService) {
        self.service = service
    }

    func saveJoke(joke: String) {
        service.save(joke)
    }
}
