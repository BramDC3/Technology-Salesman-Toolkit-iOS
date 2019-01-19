//
//  InstructionRepository.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 16/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation
import RealmSwift

struct InstructionDao {
    
    static func getInstructions() -> Results<Instruction> {
        let realm = try! Realm()
        let instructions = realm.objects(Instruction.self)
        return instructions
    }
    
    static func addInstructions(instructions: [Instruction]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getInstructions().filter { $0.serviceId == instructions.first?.serviceId })
            realm.add(instructions)
        }
    }
    
}
