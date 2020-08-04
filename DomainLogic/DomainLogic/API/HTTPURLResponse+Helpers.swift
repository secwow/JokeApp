import Foundation

extension HTTPURLResponse {
    var isOK: Bool {
        return statusCode == 200
    }
}
