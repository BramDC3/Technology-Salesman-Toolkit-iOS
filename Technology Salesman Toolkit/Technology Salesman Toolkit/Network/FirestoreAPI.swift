import Foundation
import Firebase

/**
 Contains functions used to read services from and write services to the Firestore.
 
 The Firebase documentation by Google was used as guide
 during the creation of the Firestore and its functions.
 SOURCE: https://firebase.google.com/docs/firestore/query-data/get-data
 SOURCE: https://firebase.google.com/docs/firestore/manage-data/add-data
 */
class FirestoreAPI {
    
    /**
     Instance of the firestore api so it can be accessed anywhere
     and it will always be the same firestore api.
     */
    static let instance = FirestoreAPI()
    
    /// Instance of the Firestore used for reading and writing.
    private let db = Firestore.firestore()
    
    /**
     Fetching all services from the Firestore.
     
     - Parameter completion: Function to execute after the services are fetched
                             or when an error occurs during the fetching.
     */
    func fetchServices(_ completion: @escaping ([Service]?) -> Void) {
        var services: [Service] = []
        
        db.collection("Services").getDocuments(source: FirestoreSource.server) { (querySnapshot, err) in
            guard err == nil else {
                print("Error getting documents: \(err!)")
                completion(nil)
                return
            }
            
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
    
    /**
     Fetching all instructions of a specific service from the Firestore.
     
     - Parameters:
        - serviceId: Identifier of the service which the instructions belong to.
        - completion: Function to execute after the instructions are fetched
                      or when an error occurs during the fetching.
     */
    func fetchInstructions(with serviceId: String, completion: @escaping ([Instruction]?) -> Void) {
        var instructions: [Instruction] = []
        
        db.collection("Instructions").whereField("serviceId", isEqualTo: serviceId).order(by: "index").getDocuments(source: FirestoreSource.server) { (querySnapshot, err) in
            guard err == nil else {
                print("Error getting documents: \(err!)")
                completion(nil)
                return
            }
            
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
    
    /**
     Posting a suggestion of a user to the Firestore.
     
     - Parameters:
        - suggestion: The suggestion the user wants to post.
        - completion: Function to execute after the suggestion is posted
                      or when an error occurred during the posting.
     */
    func postSuggestion(_ suggestion: String, completion: @escaping (Bool) -> Void) {
        db.collection("Suggestions").addDocument(data: [
            "message": suggestion,
            "sender": String(FirebaseUtils.firebaseUser!.uid)
        ]) { (err) in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false)
            } else {
                print("Document successfully written!")
                completion(true)
            }
        }
    }

}
