import Foundation

class AddNewJokeViewModel {
    private let service: JokesSavingService
    var onClose: (() -> ())?
    var onSave: (() -> ())?
    
    init(service: JokesSavingService) {
        self.service = service
    }

    func saveJoke(joke: String) {
        service.save(joke)
        onSave?()
    }
    
    func close() {
        onClose?()
    }
}
