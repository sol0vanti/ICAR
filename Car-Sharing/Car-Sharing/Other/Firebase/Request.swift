import Foundation

struct Request: Identifiable {
    var id: String
    var email: String
    var brands: [String]
    var models: [String]
    var indicators: [String]
}
