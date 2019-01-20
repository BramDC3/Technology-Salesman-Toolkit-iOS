import XCTest
import RealmSwift
@testable import Technology_Salesman_Toolkit

class ServiceDaoTests: XCTestCase {
    
    let serviceDaoMock = ServiceDaoMock()

    override func setUp() {
        super.setUp()
        
        let realm = DatabaseTestUtils.getRealm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func testAddThreeServices_DatabaseContainsThreeServices() {
        let service1 = Service(id: "s1", name: "service 1", description: "description of service 1", created: Date.init(), price: 1.0, image: "http://svanimpe.be/")
        let service2 = Service(id: "s2", name: "service 2", description: "description of service 2", created: Date.init(), price: 2.0, image: "http://rond-de-tafel.be/")
        let service3 = Service(id: "s3", name: "service 3", description: "description of service 3", created: Date.init(), price: 3.0, image: "https://www.patreon.com/svanimpe/")
        let services = [service1, service2, service3]
        
        serviceDaoMock.add(services)
        
        XCTAssertEqual(serviceDaoMock.getServices().count, 3)
    }
    
    func testAddThreeServices_DeleteAllServices_DatabaseContainsZeroServices() {
        let service1 = Service(id: "s1", name: "service 1", description: "description of service 1", created: Date.init(), price: 1.0, image: "http://svanimpe.be/")
        let service2 = Service(id: "s2", name: "service 2", description: "description of service 2", created: Date.init(), price: 2.0, image: "http://rond-de-tafel.be/")
        let service3 = Service(id: "s3", name: "service 3", description: "description of service 3", created: Date.init(), price: 3.0, image: "https://www.patreon.com/svanimpe/")
        let services = [service1, service2, service3]
        
        serviceDaoMock.add(services)
        
        let realm = DatabaseTestUtils.getRealm()
        try! realm.write {
            realm.deleteAll()
        }
        
        XCTAssertEqual(serviceDaoMock.getServices().count, 0)
    }
    
    func testAddThreeServices_addTwoServices_DatabaseContainsTwoServices() {
        let service1 = Service(id: "s1", name: "service 1", description: "description of service 1", created: Date.init(), price: 1.0, image: "http://svanimpe.be/")
        let service2 = Service(id: "s2", name: "service 2", description: "description of service 2", created: Date.init(), price: 2.0, image: "http://rond-de-tafel.be/")
        let service3 = Service(id: "s3", name: "service 3", description: "description of service 3", created: Date.init(), price: 3.0, image: "https://www.patreon.com/svanimpe/")
        var services = [service1, service2, service3]
        
        serviceDaoMock.add(services)
        
        let service4 = Service(id: "s4", name: "service 4", description: "description of service 4", created: Date.init(), price: 4.0, image: "https://github.com/svanimpe")
        let service5 = Service(id: "s5", name: "service 5", description: "description of service 5", created: Date.init(), price: 5.0, image: "https://twitter.com/svanimpe")
        services = [service4, service5]
        
        serviceDaoMock.add(services)
        
        XCTAssertEqual(serviceDaoMock.getServices().count, 2)
    }
    
}
