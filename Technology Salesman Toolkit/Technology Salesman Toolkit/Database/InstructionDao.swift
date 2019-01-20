import Foundation
import RealmSwift

/**
 Contains queries used to retrieve instructions from
 and write instructions to the local database.
 
 The 'RealmProjectManager' project of Pieter Van Der Helst
 guided me during the creation of the Realm database and its models.
 SOURCE: https://github.com/Pieter-hogent/RealmProjectManager
 */
class InstructionDao {
    
    /**
     Instance of the instruction dao so it can be accessed anywhere
     and it will always be the same instruction dao.
     */
    static let instance = InstructionDao()
    
    /**
     Retrieving all instructions from the local database.
     
     - Returns: A list of persisted instructions.
     */
    func getInstructions(from serviceId: String) -> Results<Instruction> {
        let realm = try! Realm()
        let instructions = realm.objects(Instruction.self).filter("serviceId = %@", serviceId)
        return instructions
    }
    
    /**
     Persisting a list of instructions to the local database.
     Also removing all old instructions matching the service
     identifier of the old ones to prevent duplication and
     outdated instructions.
     
     - Parameter instructions: Instructions that need to be persisted.
     */
    func add(_ instructions: [Instruction]) {
        let realm = try! Realm()
        try! realm.write {
            if !instructions.isEmpty { realm.delete(getInstructions(from: instructions.first!.serviceId)) }
            realm.add(instructions)
        }
    }
    
}
