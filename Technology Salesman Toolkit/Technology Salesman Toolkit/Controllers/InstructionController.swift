import Foundation

class InstructionController {
    
    static let instance = InstructionController()
    
    private var instructions: [Instruction] = []
    private var realmInstructions: [Instruction] = []
    private var serviceId: String = ""
    
    init() {
        fetchInstructionsFromLocalDatabase()
    }
    
    func getInstructions() -> [Instruction] {
        return instructions
    }
    
    func setServiceId(to serviceId: String) {
        instructions.removeAll()
        self.serviceId = serviceId
        fetchInstructionsFromNetwork()
    }
    
    private func fetchInstructionsFromNetwork() {
        FirestoreAPI.fetchInstructions(with: serviceId) { (instructions) in
            if let instructions = instructions {
                self.instructions = instructions
                InstructionDao.add(instructions)
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
    
    private func fetchInstructionsFromLocalDatabase() {
        realmInstructions = Array(InstructionDao.getInstructions())
    }
    
    // https://learnappmaking.com/notification-center-how-to-swift/
    private func postNotification() {
        NotificationCenter.default.post(name: .didFetchInstructions, object: nil)
    }
    
}

// https://learnappmaking.com/notification-center-how-to-swift/
extension Notification.Name {
    static let didFetchInstructions = Notification.Name("didFetchInstructions")
}

