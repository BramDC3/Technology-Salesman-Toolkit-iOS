import Foundation
import RealmSwift

/**
 Part of a set of instructions used to guide
 technology salesmen when carrying out a service.
 
 The 'RealmProjectManager' project of Pieter Van Der Helst
 was used as guide during the creation of the Realm database and its models.
 SOURCE: https://github.com/Pieter-hogent/RealmProjectManager
 */
class Instruction : Object {
    
    /// Identifier of the instruction.
    @objc dynamic var id: String = ""
    
    /// Title of the instruction.
    @objc dynamic var title: String = ""
    
    /// Description of the instruction.
    /// Using the name 'description' caused problems with Realm.
    @objc dynamic var shortDescription: String = ""
    
    /// List of steps of the instruction.
    var content: List<String> = List<String>()
    
    /// Link of the image of the instruction.
    @objc dynamic var image: String = ""
    
    /// Identifier of the service this instruction belongs to.
    @objc dynamic var serviceId: String = ""
    
    /// Index of the instruction in the list of instructions of the service.
    @objc dynamic var index: Int = 0
    
    /**
     Initializes an instruction with data from the local database.
     
     - Parameters:
        - id: Identifier of the instruction.
        - title: Title of the instruction.
        - description: Description of the instruction.
        - content: List of steps of the instruction.
        - image: Link of the image of the instruction.
        - serviceId: Identifier of the service this instruction belongs to.
        - index: Index of the instruction in the list of instructions of the service.
     
     - Returns: An instruction that is a part of the set of instructions of a service.
     */
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
    
    /**
     Initializes an instruction with data from the network.
     
     - Parameters:
     - dictionary: All data needed to initialize an instruction.
     - id: Identifier of the instruction.
     
     - Returns: An instruction that is a part of the set of instructions of a service.
     */
    convenience init?(dictionary: [String : Any], id: String) {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let content = dictionary["content"] as? [String],
            let image = dictionary["image"] as? String,
            let serviceId = dictionary["serviceId"] as? String,
            let index = dictionary["index"] as? Int
            else { return nil }
        
        self.init()
        self.id = id
        self.title = title
        self.shortDescription = description
        self.content = FirebaseUtils.convertToList(content)
        self.image = image
        self.serviceId = serviceId
        self.index = index
    }
}
