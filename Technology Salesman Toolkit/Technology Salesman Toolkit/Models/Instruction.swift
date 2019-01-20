import Foundation
import RealmSwift

class Instruction : Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var shortDescription: String = ""
    var content: List<String> = List<String>()
    @objc dynamic var image: String = ""
    @objc dynamic var serviceId: String = ""
    @objc dynamic var index: Int = 0
    
    convenience init(id: String, title: String, description: String, content: List<String>, image: String, serviceId: String, index: Int) {
        self.init()
        self.id = id
        self.title = title
        self.shortDescription = description
        self.content = content
        self.image = image
        self.serviceId = serviceId
        self.index = index
    }
    
    convenience init?(dictionary: [String : Any], id: String) {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let contentArray = dictionary["content"] as? [String],
            let image = dictionary["image"] as? String,
            let serviceId = dictionary["serviceId"] as? String,
            let index = dictionary["index"] as? Int
            else { return nil }
        
        let content = List<String>()
        content.append(objectsIn: contentArray)
        
        self.init(id: id, title: title, description: description, content: content, image: image, serviceId: serviceId, index: index)
    }
}
