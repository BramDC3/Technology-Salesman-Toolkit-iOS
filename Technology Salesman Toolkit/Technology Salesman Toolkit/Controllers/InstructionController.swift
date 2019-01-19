//
//  InstructionController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 19/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation

class InstructionController {
    static let shared = InstructionController()
    
    private var instructions: [Instruction] = []
    private var realmInstructions: [Instruction] = []
    private var serviceId: String = ""
    
    init() {
        fetchInstructionsFromRealm()
    }
    
    func getInstructions() -> [Instruction] {
        return instructions
    }
    
    func setServiceId(toServiceId serviceId: String) {
        instructions.removeAll()
        self.serviceId = serviceId
        fetchInstructionsFromFirestore()
    }
    
    private func fetchInstructionsFromRealm() {
        realmInstructions = Array(InstructionDao.getInstructions())
    }
    
    private func fetchInstructionsFromFirestore() {
        FirestoreAPI.fetchInstructions(fromService: serviceId) { (instructions) in
            if let instructions = instructions {
                self.instructions = instructions
                InstructionDao.addInstructions(instructions: instructions)
            } else {
                let filteredInstructions = self.realmInstructions.filter {
                    $0.serviceId == self.serviceId
                }
                if !filteredInstructions.isEmpty {
                    self.instructions = filteredInstructions
                }
            }
            self.postNotification()
        }
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: .didFetchInstructions, object: nil)
    }
    
}

extension Notification.Name {
    static let didFetchInstructions = Notification.Name("didFetchInstructions")
}

