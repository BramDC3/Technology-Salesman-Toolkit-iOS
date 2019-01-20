import Foundation

class ServiceController {
    
    static let instance = ServiceController()
    
    private var allServices: [Service] = []
    private var realmServices: [Service] = []
    private var filteredServices: [Service] = []
    private var isLoading: Bool = false
    private var nameFilter: String = ""
    
    init() {
        fetchServicesFromNetwork()
        fetchServicesFromLocalDatabase()
    }
    
    func getServices() -> [Service] {
        return filteredServices
    }
    
    func setNameFilter(to name: String) {
        nameFilter = name
        refreshServiceList()
    }
    
    private func fetchServicesFromNetwork() {
        isLoading = true
        
        FirestoreAPI.fetchServices() { (services) in
            self.isLoading = false
            
            if let services = services {
                self.allServices = services
                ServiceDao.add(services)
            } else if !self.realmServices.isEmpty {
                self.allServices = self.realmServices
            }
            
            self.refreshServiceList()
        }
    }
    
    private func fetchServicesFromLocalDatabase() {
        realmServices = Array(ServiceDao.getServices())
        
        if allServices.isEmpty && isLoading == false {
            allServices = realmServices
            refreshServiceList()
        }
    }
    
    private func refreshServiceList() {
        filteredServices = allServices.filter {
            nameFilter == "" || $0.name.lowercased().contains(nameFilter.lowercased())
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
