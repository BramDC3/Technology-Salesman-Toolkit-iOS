import Foundation
import RealmSwift

struct InstructionDao {
    
    static func getInstructions() -> Results<Instruction> {
        let realm = try! Realm()
        let instructions = realm.objects(Instruction.self)
        return instructions
    }
    
    static func add(_ instructions: [Instruction]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getInstructions().filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
    }
    
}
