import Foundation
import Firebase
import RealmSwift

enum Category: String {
    case windows = "Windows"
    case android = "Android"
    case apple = "Apple"
    case other = "Andere"
}

class Service {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var description: String = ""
    @objc dynamic var categoryRaw: String = ""
    var category: Category {
        get {
            return Category(rawValue: categoryRaw) ?? .other
        }
        set {
            categoryRaw = newValue.rawValue
        }
    }
    @objc dynamic var created: Timestamp = Timestamp.init()
    @objc dynamic var price: Double = 0.0
    @objc dynamic var image: String = ""
    
    convenience init(id: String, name: String, description: String, created: Timestamp, price: Double, image: String, category: Category = .other) {
        self.init()
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.created = created
        self.price = price
        self.image = image
    }

    convenience init?(dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let category = dictionary["category"] as? Int,
            let created = dictionary["created"] as? Timestamp,
            let price = dictionary["price"] as? Double,
            let image = dictionary["image"] as? String
            else { return nil }
        
        self.init(id: id, name: name, description: description, created: created, price: price, image: image, category: FirebaseUtils.convertIntToCategory(int: category))
    }
}
