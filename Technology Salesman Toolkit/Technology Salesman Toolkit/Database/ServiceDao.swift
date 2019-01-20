import Foundation
import RealmSwift

struct ServiceDao {
    
    static func getServices() -> Results<Service> {
        let realm = try! Realm()
        let services = realm.objects(Service.self)
        return services
    }
    
    static func add(_ services: [Service]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getServices())
            realm.add(services)
        }
    }
    
}
