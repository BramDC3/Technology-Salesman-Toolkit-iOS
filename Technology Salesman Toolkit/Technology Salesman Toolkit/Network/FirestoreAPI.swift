import Foundation
import Firebase

struct FirestoreAPI {
    
    // https://firebase.google.com/docs/firestore/quickstart
    static func fetchServices(completion: @escaping ([Service]?) -> Void) {
        // Firestore settings to use Timestamps instead of Date objects
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        var services: [Service] = []
        
        db.collection("Services").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                for document in querySnapshot!.documents {
                    if let service = Service(dictionary: document.data(), id: document.documentID) {
                        services.append(service)
                    } else {
                        fatalError("Unable to initialize type \(Service.self) with dictionary \(document.data())")
                    }
                }
                completion(services)
            }
        }
    }
    
    static func fetchInstructions(fromService serviceId: String, completion: @escaping ([Instruction]?) -> Void) {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        var instructions: [Instruction] = []
        
        db.collection("Instructions").whereField("serviceId", isEqualTo: serviceId).order(by: "index").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                for document in querySnapshot!.documents {
                    if let instruction = Instruction(dictionary: document.data(), id: document.documentID) {
                        instructions.append(instruction)
                    } else {
                        fatalError("Unable to initialize type \(Instruction.self) with dictionary \(document.data())")
                    }
                }
                completion(instructions)
            }
        }
    }

}
