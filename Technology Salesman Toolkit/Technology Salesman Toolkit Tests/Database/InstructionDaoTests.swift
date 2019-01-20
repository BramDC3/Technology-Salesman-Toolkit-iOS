import XCTest
import RealmSwift
@testable import Technology_Salesman_Toolkit

class InstructionDaoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        let realm = DatabaseTestUtils.getRealm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func testAddThreeInstructions_DatabaseContainsThreeInstructions() {
        let realm = DatabaseTestUtils.getRealm()
        var realmInstructions = realm.objects(Instruction.self)
        
        XCTAssertEqual(realmInstructions.count, 0)
        
        let instruction1 = Instruction(id: "1", title: "instruction 1", description: "description of instruction 1", content: FirebaseUtils.convertToList([String]()), image: "http://svanimpe.be/", serviceId: "1", index: 0)
        let instruction2 = Instruction(id: "2", title: "instruction 2", description: "description of instruction 2", content: FirebaseUtils.convertToList([String]()), image: "http://rond-de-tafel.be/", serviceId: "1", index: 1)
        let instruction3 = Instruction(id: "3", title: "instruction 3", description: "description of instruction 3", content: FirebaseUtils.convertToList([String]()), image: "https://www.patreon.com/svanimpe/", serviceId: "1", index: 2)
        let instructions = [instruction1, instruction2, instruction3]
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
        
        realmInstructions = realm.objects(Instruction.self)
        
        XCTAssertEqual(realmInstructions.count, 3)
    }
    
    func testAddThreeInstructionsFromFirstService_AddTwoInstructionsFromFirstService_DatabaseContainsTwoInstructions() {
        let realm = DatabaseTestUtils.getRealm()
        var realmInstructions = realm.objects(Instruction.self)
        
        XCTAssertEqual(realmInstructions.count, 0)
        
        let instruction1 = Instruction(id: "1", title: "instruction 1", description: "description of instruction 1", content: FirebaseUtils.convertToList([String]()), image: "http://svanimpe.be/", serviceId: "1", index: 0)
        let instruction2 = Instruction(id: "2", title: "instruction 2", description: "description of instruction 2", content: FirebaseUtils.convertToList([String]()), image: "http://rond-de-tafel.be/", serviceId: "1", index: 1)
        let instruction3 = Instruction(id: "3", title: "instruction 3", description: "description of instruction 3", content: FirebaseUtils.convertToList([String]()), image: "https://www.patreon.com/svanimpe/", serviceId: "1", index: 2)
        var instructions = [instruction1, instruction2, instruction3]
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
        
        let instruction4 = Instruction(id: "4", title: "instruction 4", description: "description of instruction 4", content: FirebaseUtils.convertToList([String]()), image: "https://github.com/svanimpe", serviceId: "1", index: 0)
        let instruction5 = Instruction(id: "5", title: "instruction 5", description: "description of instruction 5", content: FirebaseUtils.convertToList([String]()), image: "https://twitter.com/svanimpe", serviceId: "1", index: 1)
        instructions = [instruction4, instruction5]
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
        
        realmInstructions = realm.objects(Instruction.self)
        
        XCTAssertEqual(realmInstructions.count, 2)
    }
    
    func testAddThreeInstructionsFromFirstService_AddTwoInstructionsFromSecondService_DatabaseContainsFiveInstructions() {
        let realm = DatabaseTestUtils.getRealm()
        var realmInstructions = realm.objects(Instruction.self)
        
        XCTAssertEqual(realmInstructions.count, 0)
        
        let instruction1 = Instruction(id: "1", title: "instruction 1", description: "description of instruction 1", content: FirebaseUtils.convertToList([String]()), image: "http://svanimpe.be/", serviceId: "1", index: 0)
        let instruction2 = Instruction(id: "2", title: "instruction 2", description: "description of instruction 2", content: FirebaseUtils.convertToList([String]()), image: "http://rond-de-tafel.be/", serviceId: "1", index: 1)
        let instruction3 = Instruction(id: "3", title: "instruction 3", description: "description of instruction 3", content: FirebaseUtils.convertToList([String]()), image: "https://www.patreon.com/svanimpe/", serviceId: "1", index: 2)
        var instructions = [instruction1, instruction2, instruction3]
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
        
        let instruction4 = Instruction(id: "4", title: "instruction 4", description: "description of instruction 4", content: FirebaseUtils.convertToList([String]()), image: "https://github.com/svanimpe", serviceId: "2", index: 0)
        let instruction5 = Instruction(id: "5", title: "instruction 5", description: "description of instruction 5", content: FirebaseUtils.convertToList([String]()), image: "https://twitter.com/svanimpe", serviceId: "2", index: 1)
        instructions = [instruction4, instruction5]
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
        
        realmInstructions = realm.objects(Instruction.self)
        
        XCTAssertEqual(realmInstructions.count, 5)
    }
    
    func testAddThreeInstructionsFromFirstService_AddTwoInstructionsFromSecondService_DeleteInstructionsOfFirstService_DatabaseContainsTwoInstructions() {
        let realm = DatabaseTestUtils.getRealm()
        var realmInstructions = realm.objects(Instruction.self)
        
        XCTAssertEqual(realmInstructions.count, 0)
        
        let instruction1 = Instruction(id: "1", title: "instruction 1", description: "description of instruction 1", content: FirebaseUtils.convertToList([String]()), image: "http://svanimpe.be/", serviceId: "1", index: 0)
        let instruction2 = Instruction(id: "2", title: "instruction 2", description: "description of instruction 2", content: FirebaseUtils.convertToList([String]()), image: "http://rond-de-tafel.be/", serviceId: "1", index: 1)
        let instruction3 = Instruction(id: "3", title: "instruction 3", description: "description of instruction 3", content: FirebaseUtils.convertToList([String]()), image: "https://www.patreon.com/svanimpe/", serviceId: "1", index: 2)
        var instructions = [instruction1, instruction2, instruction3]
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
        
        let instruction4 = Instruction(id: "4", title: "instruction 4", description: "description of instruction 4", content: FirebaseUtils.convertToList([String]()), image: "https://github.com/svanimpe", serviceId: "2", index: 0)
        let instruction5 = Instruction(id: "5", title: "instruction 5", description: "description of instruction 5", content: FirebaseUtils.convertToList([String]()), image: "https://twitter.com/svanimpe", serviceId: "2", index: 1)
        instructions = [instruction4, instruction5]
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
        
        realmInstructions = realm.objects(Instruction.self)
        
        try! realm.write {
            realm.delete(realm.objects(Instruction.self).filter { $0.serviceId == "1" })
        }
        
        XCTAssertEqual(realmInstructions.count, 2)
        XCTAssertEqual(realmInstructions.first?.serviceId, "2")
    }

}
