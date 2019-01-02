import Foundation
import Firebase

struct Service {
    let id: String
    let name: String
    let description: String
    let category: Category
    let created: Timestamp
    let price: Double
    let image: String
}

enum Category {
    case Windows, Android, Apple, Other
}

extension Service {
    init?(dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let category = dictionary["category"] as? Int,
            let created = dictionary["created"] as? Timestamp,
            let price = dictionary["price"] as? Double,
            let image = dictionary["image"] as? String
            else { return nil }
        
        self.init(
            id: id,
            name: name,
            description: description,
            category: FirebaseUtils.convertIntToCategory(int: category),
            created: created,
            price: price,
            image: image
        )
    }
}
