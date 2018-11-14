import Foundation

struct Service {
    let id: String
    let name: String
    let description: String
    let category: Category
    let created: NSDate
    let price: Double
    let image: String
    let url: String
}

enum Category {
    case Windows, Android, Apple, Other
}
