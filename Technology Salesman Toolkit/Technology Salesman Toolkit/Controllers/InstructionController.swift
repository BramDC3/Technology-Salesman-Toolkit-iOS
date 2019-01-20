import Foundation

/**
 Controller for all instructions, coming from
 both the network and the local database.
 */
class InstructionController {
    
    /**
     Instance of the instruction controller so it can be accessed anywhere
     and it will always be the same instruction controller.
     */
    static let instance = InstructionController()
    
    /// List of all instructions, that should remain untouched.
    private var instructions: [Instruction] = []
    
    /// List of all instructions coming from the local database.
    private var localInstructions: [Instruction] = []
    
    /// Identifier of the service which instructions are needed.
    private var serviceId: String = ""
    
    /**
     Getter that retrieves the list instructions of a certain service.
     
     - Returns: A list of instructions.
     */
    func getInstructions() -> [Instruction] {
        return instructions
    }
    
    /**
     Selecting the service which instructions are needed.
     Also removing the instructions of the previous selected service
     and start fetching the needed instructions from the network.
     
     - Parameter serviceId: Identifier of a service.
     */
    func setServiceId(to serviceId: String) {
        fetchAllInstructionsFromLocalDatabase()
        instructions.removeAll()
        self.serviceId = serviceId
        fetchInstructionsFromLocalDatabase()
        fetchInstructionsFromNetwork()
    }
    
    /**
     Fetching the instructions from the network.
     Also replace the list of instructions with
     instructions from the local database if
     none were retrieved from the network.
     */
    private func fetchInstructionsFromNetwork() {
        FirestoreAPI.fetchInstructions(with: serviceId) { (instructions) in
            if let instructions = instructions {
                self.instructions = instructions
                if !self.localDatabaseContainsInstructionsOfSelectedService() {
                    self.postNotification()
                }
                InstructionDao.add(instructions)
            }
        }
    }
    
    /// Fetching instructions from the local database of a certain service.
    private func fetchInstructionsFromLocalDatabase() {
        if localDatabaseContainsInstructionsOfSelectedService() {
            let filteredInstructions = localInstructions.filter { $0.serviceId == serviceId }
            instructions = filteredInstructions
            self.postNotification()
        }
    }
    
    /**
     Checking whether the local database contains instructions of the selected service or not.
     
     - Returns: Indication whether the local database contains instructions of the selected service or not.
     */
    private func localDatabaseContainsInstructionsOfSelectedService() -> Bool {
        return localInstructions.filter { $0.serviceId == serviceId }.count != 0
    }
    
    /// Fetching all instructions from the local database.
    private func fetchAllInstructionsFromLocalDatabase() {
        localInstructions = Array(InstructionDao.getInstructions())
    }
    
    /// Posts a notification to notify observers of any changes to the list of instructions.
    /// SOURCE: https://learnappmaking.com/notification-center-how-to-swift/
    private func postNotification() {
        NotificationCenter.default.post(name: .didFetchInstructions, object: nil)
    }
    
}

/// Name of the notification that is posted when the instructions are fetched.
/// SOURCE: //https://learnappmaking.com/notification-center-how-to-swift/
extension Notification.Name {
    static let didFetchInstructions = Notification.Name("didFetchInstructions")
}

