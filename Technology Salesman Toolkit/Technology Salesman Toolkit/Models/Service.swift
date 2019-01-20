import Foundation
import Firebase
import RealmSwift

/// Category of a service.
enum Category: String {
    
    /// Services related to Windows.
    case windows = "Windows"
    
    /// Services related to Android.
    case android = "Android"
    
    /// Services related to Apple (both iOS and macOS).
    case apple = "Apple"
    
    /// Services related to anything else.
    case other = "Andere"
}

/**
 Guide for technology salesmen to help or assist
 customers with IT-related problems.
 
 The 'RealmProjectManager' project of Pieter Van Der Helst
 was used as guide during the creation of the Realm database and its models.
 SOURCE: https://github.com/Pieter-hogent/RealmProjectManager
 */
class Service : Object {
    
    /// Identifier of the service.
    @objc dynamic var id: String = ""
    
    /// Name of the service.
    @objc dynamic var name: String = ""
    
    /// Description of the service.
    /// Using the name 'description' caused problems with Realm.
    @objc dynamic var shortDescription: String = ""
    
    /// Raw category that can be stored in the Realm database.
    @objc dynamic var categoryRaw: String = ""
    
    /// Actual category of the service.
    var category: Category {
        get {
            return Category(rawValue: categoryRaw) ?? .other
        }
        set {
            categoryRaw = newValue.rawValue
        }
    }
    
    /// The date on which the service was created.
    @objc dynamic var created: Date = Date.init()
    
    /// The price of the service.
    @objc dynamic var price: Double = 0.0
    
    /// Link of the logo of the service.
    @objc dynamic var image: String = ""
    
    /**
     Initializes a service with data from the local database.
     
     - Parameters:
        - id: Identifier of the service.
        - name: Name of the service.
        - description: Description of the service.
        - created: The date on which the service was created.
        - price: The price of the service.
        - image: Link of the logo of the service.
        - category: Category of the service.
     
     - Returns: A service ready to help technology salesmen.
     */
    convenience init(id: String, name: String, description: String, created: Date, price: Double, image: String, category: Category = .other) {
        self.init()
        self.id = id
        self.name = name
        self.shortDescription = description
        self.category = category
        self.created = created
        self.price = price
        self.image = image
    }

    /**
     Initializes a service with data from the network.
     
     - Parameters:
        - dictionary: All data needed to initialize a service.
        - id: Identifier of the service.
     
     - Returns: A service ready to help technology salesmen.
     */
    convenience init?(dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let categoryInt = dictionary["category"] as? Int,
            let created = dictionary["created"] as? Timestamp,
            let price = dictionary["price"] as? Double,
            let image = dictionary["image"] as? String
            else { return nil }
        
        self.init()
        self.id = id
        self.name = name
        self.shortDescription = description
        self.category = FirebaseUtils.convertToCategory(categoryInt)
        self.created = created.dateValue()
        self.price = price
        self.image = image
    }
}
