import Foundation

protocol OfflineNameReplacer {
    func makeNetwork(disabled: Bool)
    func update(name: String)
}
