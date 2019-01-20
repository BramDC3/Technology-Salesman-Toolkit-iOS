import UIKit

class ServiceTableViewController: UITableViewController {
    
    var services: [Service] = []
    
    // https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        
        // https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
        // Setup the Search Controller
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
        
        // https://learnappmaking.com/notification-center-how-to-swift/
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveNotification(_:)), name: .didFetchServices, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .didFetchServices, object: nil)
    }
    
    // The number of sections, 1 is default but I want to clearly define this table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return services.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else {
            fatalError("Could not dequeue a cell.")
        }
        
        let service = services[indexPath.row]

        cell.titleLabel.text = service.name
        cell.descriptionLabel.text = service.shortDescription
        cell.categoryLabel.text = "\(service.category.rawValue)"
        cell.priceLabel.text = service.price == 0.0 ? " " : StringUtils.formatPrice(service.price)
        
        if let link = URL(string: service.image) {
            FirebaseUtils.fetchImage(with: link) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    cell.logoImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToServiceDetail", sender: indexPath);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToServiceDetail" {
            let index = (sender as! IndexPath).row
            let detailViewController = segue.destination as! ServiceDetailViewController
            detailViewController.service = services[index]
        }
    }
    
    @objc private func onReceiveNotification(_ notification: Notification) {
        updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.services = ServiceController.instance.getServices()
            self.tableView.reloadData()
        }
    }
    
    private func filterByName(_ name: String) {
        ServiceController.instance.setNameFilter(to: name)
    }

}

// https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
extension ServiceTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterByName(searchController.searchBar.text!)
    }
}
