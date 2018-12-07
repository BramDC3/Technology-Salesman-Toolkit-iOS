import Foundation
import Firebase

struct FirestoreAPI {
    
    // https://firebase.google.com/docs/firestore/quickstart
    func getServices() {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("Services").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let service = Service(dictionary: document.data(), id: document.documentID) {
                        print(service.name)
                    } else {
                        fatalError("Unable to initialize type \(Service.self) with dictionary \(document.data())")
                    }
                }
            }
        }
    }

}
