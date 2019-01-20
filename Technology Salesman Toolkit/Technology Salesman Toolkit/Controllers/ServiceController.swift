import Foundation

/**
 Controller for all services, coming from
 both the network and the local database.
 */
class ServiceController {
    
    /**
     Instance of the service controller so it can be accessed anywhere
     and it will always be the same service controller.
     */
    static let instance = ServiceController()
    
    /// List of all services, that should remain untouched.
    private var allServices: [Service] = []
    
    /// List of all services coming from the local database.
    private var localServices: [Service] = []
    
    /// List of services that is filtered and ready to be displayed.
    private var filteredServices: [Service] = []
    
    /// Filter to only have services where the name contains this word.
    private var nameFilter: String = ""
    
    /**
     Initializes a new service controller and starts fetching
     services from the network and the local database.
     */
    init() {
        fetchServicesFromNetwork()
        fetchServicesFromLocalDatabase()
    }
    
    /**
     Getter that retrieves the list of filtered services.
     
     - Returns: The list of filtered services.
     */
    func getServices() -> [Service] {
        return filteredServices
    }
    
    /**
     Setter for the name filter.
     
     - Parameter name: The word that needs to be filtered on.
    */
    func setNameFilter(to name: String) {
        nameFilter = name
        refreshServiceList()
    }
    
    /**
     Fetching the services from the network.
     Also replace the list of all services with the
     services from the local database if none were
     retrieved from the network.
     */
    private func fetchServicesFromNetwork() {
        FirestoreAPI.instance.fetchServices() { (services) in

            if let services = services {
                self.allServices = services
                ServiceDao.instance.add(services)
            } else if !self.localServices.isEmpty {
                self.allServices = self.localServices
            }
            
            self.refreshServiceList()
        }
    }
    
    /**
     Fetching the services from the local database.
     Also replace the list of all services with the services
     from the local database, if loading services from the network
     is done and none are retrieved.
     */
    private func fetchServicesFromLocalDatabase() {
        localServices = Array(ServiceDao.instance.getServices())
        
        if allServices.isEmpty {
            allServices = localServices
            refreshServiceList()
        }
    }
    
    /**
     Function to refresh the list of filtered services.
     Also posting a notification to notify observers of the change.
     */
    private func refreshServiceList() {
        filteredServices = allServices.filter {
            nameFilter == "" || $0.name.lowercased().contains(nameFilter.lowercased())
        }
        
        postNotification()
    }
    
    /// Posts a notification to notify observers of any changes to the list of services.
    /// SOURCE: https://learnappmaking.com/notification-center-how-to-swift/
    private func postNotification() {
        NotificationCenter.default.post(name: .didFetchServices, object: nil)
    }
    
}

/// Name of the notification that is posted when the services are fetched.
/// SOURCE: //https://learnappmaking.com/notification-center-how-to-swift/
extension Notification.Name {
    static let didFetchServices = Notification.Name("didFetchServices")
}
