import Foundation
import RealmSwift

/**
 Contains queries used to retrieve services from
 and write services to the local database.
 
 The 'RealmProjectManager' project of Pieter Van Der Helst
 guided me during the creation of the Realm database and its models.
 SOURCE: https://github.com/Pieter-hogent/RealmProjectManager
 */
struct ServiceDao {
    
    /**
     Retrieving all services from the local database.
     
     - Returns: A list of persisted services.
     */
    static func getServices() -> Results<Service> {
        let realm = try! Realm()
        let services = realm.objects(Service.self)
        return services
    }
    
    /**
     Persisting a list of services to the local database.
     Also removing all old services to prevent duplication
     and outdated services.
     
     - Parameter services: Services that need to be persisted.
    */
    static func add(_ services: [Service]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getServices())
            realm.add(services)
        }
    }
    
}
