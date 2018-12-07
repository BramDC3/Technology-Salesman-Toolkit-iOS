import Foundation
import Firebase

struct FirestoreAPI {
    
    // https://firebase.google.com/docs/firestore/quickstart
    func getServices() -> [Service]? {
        
        // Firestore settings to use Timestamps instead of Date objects
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        var services: [Service] = []
        
        db.collection("Services").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let service = Service(dictionary: document.data(), id: document.documentID) {
                        print(service.name)
                        services.append(service)
                    } else {
                        fatalError("Unable to initialize type \(Service.self) with dictionary \(document.data())")
                    }
                }
            }
        }
        
        return services
    }

}
