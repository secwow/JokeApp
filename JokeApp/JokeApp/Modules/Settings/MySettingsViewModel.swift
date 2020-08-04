import Foundation

class MySettingsViewModel: SettingsViewModel {
    private let networkInstructor: OfflineNameReplacer
    
    init(networkInstructor: OfflineNameReplacer) {
        self.networkInstructor = networkInstructor
    }
    
    func switchNetwork(on: Bool) {
        networkInstructor.makeNetwork(disabled: on)
    }
    
    func update(name: String) {
        networkInstructor.update(name: name)
    }
}
