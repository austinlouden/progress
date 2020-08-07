import Foundation

struct Project: Codable {
    var id: Int
    var name: String
    var progress: Double
    var modificationDate: Date
}