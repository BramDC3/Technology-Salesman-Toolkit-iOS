//
//  ServiceController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 19/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation

class ServiceController {
    static let shared = ServiceController()
    
    private var allServices: [Service] = []
    private var realmServices: [Service] = []
    private var isLoading: Bool = false
    
    var filteredServices: [Service] = []
    var nameFilter: String = ""
    var categoryFilter: Category? = nil
    
    init() {
        fetchServicesFromFirestore()
        fetchServicesFromRealm()
    }
    
    private func fetchServicesFromFirestore() {
        isLoading = true
        FirestoreAPI.fetchServices() { (services) in
            self.isLoading = false
            if let services = services {
                self.allServices = services
                ServiceRepository.addServices(services: services)
            } else if !self.realmServices.isEmpty {
                self.allServices = self.realmServices
            }
            self.refreshServiceList()
        }
    }
    
    private func fetchServicesFromRealm() {
        realmServices = Array(ServiceRepository.getServices())
        if allServices.isEmpty && isLoading == false {
            allServices = realmServices
            refreshServiceList()
        }
    }
    
    private func refreshServiceList() {
        filteredServices = allServices.filter {
            (nameFilter == "" || $0.name.lowercased().contains(nameFilter.lowercased())) &&
            (categoryFilter == nil || $0.category == categoryFilter)
        }
        postNotification()
    }
    
    // https://learnappmaking.com/notification-center-how-to-swift/
    private func postNotification() {
        NotificationCenter.default.post(name: .didFetchServices, object: nil)
    }
    
}

//https://learnappmaking.com/notification-center-how-to-swift/
extension Notification.Name {
    static let didFetchServices = Notification.Name("didFetchServices")
}
