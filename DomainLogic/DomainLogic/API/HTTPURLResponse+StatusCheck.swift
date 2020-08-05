import Foundation

extension HTTPURLResponse {
    enum Status: Int {
        case ok = 200
        case undefined
    }
    
    var status: Status {
        return Status.init(rawValue: statusCode) ?? .undefined
    }
}
