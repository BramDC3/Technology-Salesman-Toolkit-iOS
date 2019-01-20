import Foundation
import RealmSwift

/**
 Contains queries used to retrieve instructions from
 and write instructions to the local database.
 
 The 'RealmProjectManager' project of Pieter Van Der Helst
 guided me during the creation of the Realm database and its models.
 SOURCE: https://github.com/Pieter-hogent/RealmProjectManager
 */
struct InstructionDao {
    
    /**
     Retrieving all instructions from the local database.
     
     - Returns: A list of persisted instructions.
     */
    static func getInstructions() -> Results<Instruction> {
        let realm = try! Realm()
        let instructions = realm.objects(Instruction.self)
        return instructions
    }
    
    /**
     Persisting a list of instructions to the local database.
     Also removing all old instructions matching the service
     identifier of the old ones to prevent duplication and
     outdated instructions.
     
     - Parameter instructions: Instructions that need to be persisted.
     */
    static func add(_ instructions: [Instruction]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getInstructions().filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
    }
    
}
