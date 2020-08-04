import Foundation

class AddNewJokeViewModel {
    private let service: JokesSavingService
    
    init(service: JokesSavingService) {
        self.service = service
    }

    func saveJoke(joke: String) {
        service.save(joke)
    }
}
