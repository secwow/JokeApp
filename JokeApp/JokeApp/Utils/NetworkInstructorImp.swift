import Foundation

// Resposible for switch from online to offline mode
class ReplacingState: NetworkInstructor {
    private (set) var isOffline: Bool = false
    private (set) var nameToReplace: String
    
    init() {
        self.nameToReplace = ""
    }
    
    func makeNetwork(disabled: Bool) {
        isOffline = disabled
    }
    
    func update(name: String) {
        self.nameToReplace = name
    }
}
