import Foundation

class SettingsViewModel {
    private let networkInstructor: ChuckNorrisProtocol
    
    init(networkInstructor: ChuckNorrisProtocol) {
        self.networkInstructor = networkInstructor
    }
    
    func switchNetwork(on: Bool) {
        networkInstructor.makeNetwork(disabled: on)
    }
    
    func update(name: String) {
        networkInstructor.update(name: name)
    }
}
