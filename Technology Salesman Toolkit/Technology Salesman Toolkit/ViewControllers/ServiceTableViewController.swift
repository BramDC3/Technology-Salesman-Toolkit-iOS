//
//  ServiceTableViewController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 07/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import UIKit

class ServiceTableViewController: UITableViewController {
    
    var services: [Service] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !ServiceController.shared.filteredServices.isEmpty {
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
        cell.priceLabel.text = service.price == 0.0 ? " " : StringUtils.formatPrice(price: service.price)
        
        if let link = URL(string: service.image) {
            FirebaseUtils.fetchImage(url: link) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                        return
                    }
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
            self.services = ServiceController.shared.filteredServices
            self.tableView.reloadData()
        }
    }

}
