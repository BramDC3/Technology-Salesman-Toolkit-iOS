//
//  InstructionRepository.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 16/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation
import RealmSwift

struct InstructionRepository {
    
    static func getInstructions(fromService serviceId: String) -> Results<Instruction> {
        let realm = try! Realm()
        let instructions = realm.objects(Instruction.self).filter("serviceId == \(serviceId)")
        return instructions
    }
    
    static func addInstructions(instructions: [Instruction]) {
        let realm = try! Realm()
        realm.add(instructions)
    }
    
    static func deleteInstructions(fromService serviceId: String) {
        let realm = try! Realm()
        realm.delete(getInstructions(fromService: serviceId))
    }
    
}
