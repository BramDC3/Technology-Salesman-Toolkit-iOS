import Foundation
import RealmSwift
@testable import Technology_Salesman_Toolkit

class InstructionDaoMock : InstructionDao {
    
    override func getInstructions(from serviceId: String) -> Results<Instruction> {
        let realm = DatabaseTestUtils.getRealm()
        let instructions = realm.objects(Instruction.self).filter("serviceId = %@", serviceId)
        return instructions
    }
    
    override func add(_ instructions: [Instruction]) {
        let realm = DatabaseTestUtils.getRealm()
        try! realm.write {
            if !instructions.isEmpty { realm.delete(getInstructions(from: instructions.first!.serviceId)) }
            realm.add(instructions)
        }
    }
    
}
