
import Foundation

// Recipe Model:
struct Recipe: Identifiable, Codable {
    var id = UUID()
    var description: String
    var title: String
    var headline: String
    var ingredients: [String]
    var instructions: [String]
    var imageName: String
}
