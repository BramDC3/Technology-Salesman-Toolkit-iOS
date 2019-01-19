//
//  ServiceRepository.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 16/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation
import RealmSwift

struct ServiceDao {
    
    static func getServices() -> Results<Service> {
        let realm = try! Realm()
        let services = realm.objects(Service.self)
        return services
    }
    
    static func addServices(services: [Service]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getServices())
            realm.add(services)
        }
    }
    
}
