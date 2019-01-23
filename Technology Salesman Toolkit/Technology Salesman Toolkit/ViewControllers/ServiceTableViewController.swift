import UIKit

/**
 The first view users see when they are logged in.
 It contains a list of all services.
 */
class ServiceTableViewController: UITableViewController {
    
    /// Services that are displayed in the table view.
    var services: [Service] = []
    
    /// Used to filter the services by name.
    /// SOURCE: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        
        /// Setting up the Search Controller.
        /// SOURCE: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Zoek hier..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !ServiceController.instance.getServices().isEmpty {
            updateUI()
        }
        
        /// Adding an observer that gets notified when the services are fetched.
        /// SOURCE: https://learnappmaking.com/notification-center-how-to-swift/
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveNotification(_:)), name: .didFetchServices, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /// Removing the observer that gets notified when the services are fetched.
        /// SOURCE: https://learnappmaking.com/notification-center-how-to-swift/
        NotificationCenter.default.removeObserver(self, name: .didFetchServices, object: nil)
    }
    
    /// The default number of sections of a table view is 1, but now it is clearly defined.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Defining the number of rows each section of the table view has.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return services.count
        } else {
            return 0
        }
    }

    /// Filling the cells of the table view with the data of the services.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else {
            fatalError("Could not dequeue a cell.")
        }
        
        let service = services[indexPath.row]

        cell.titleLabel.text = service.name
        cell.descriptionLabel.text = service.shortDescription
        cell.categoryLabel.text = service.category.rawValue
        cell.priceLabel.text = service.price == 0.0 ? " " : StringUtils.formatPrice(service.price)
        
        /// SOURCE: App Development with Swift page 948
        if let link = URL(string: service.image) {
            FirebaseUtils.fetchImage(with: link) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath { return }
                    cell.logoImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    /// Called when a row of the table view is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToServiceDetail", sender: indexPath);
    }
    
    /// Preparing to go to the service detail view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToServiceDetail" {
            let index = (sender as! IndexPath).row
            let detailViewController = segue.destination as! ServiceDetailViewController
            detailViewController.service = services[index]
        }
    }
    
    
    /// Called when the observer is notified.
    /// SOURCE: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    @objc private func onReceiveNotification(_ notification: Notification) {
        updateUI()
    }
    
    /// Updates the table view with the data of the services.
    private func updateUI() {
        DispatchQueue.main.async {
            self.services = ServiceController.instance.getServices()
            self.tableView.reloadData()
        }
    }
    
    /**
     Filtering the services by name.
     
     SOURCE: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
     
     - Parameter name: Name, word, or sequence of characters
                       that needs to be filtered on.
     */
    private func filterByName(_ name: String) {
        ServiceController.instance.setNameFilter(to: name)
    }

}

/// Allowing the ServiceTableViewController to respond to the search bar.
/// SOURCE: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
extension ServiceTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterByName(searchController.searchBar.text!)
    }
}
