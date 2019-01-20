import Foundation
import RealmSwift
@testable import Technology_Salesman_Toolkit

class ServiceDaoMock : ServiceDao {
    
    override func getServices() -> Results<Service> {
        let realm = DatabaseTestUtils.getRealm()
        let services = realm.objects(Service.self)
        return services
    }
    
    override func add(_ services: [Service]) {
        let realm = DatabaseTestUtils.getRealm()
        try! realm.write {
            realm.delete(getServices())
            realm.add(services)
        }
    }
    
}
