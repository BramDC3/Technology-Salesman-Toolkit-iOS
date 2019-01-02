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
        
        FirestoreAPI.fetchServices() { (services) in
                if let services = services {
                self.updateUI(with: services)
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        
        let service = services[indexPath.row]
        
        cell.textLabel?.text = service.name
        cell.detailTextLabel?.text = service.description
        
        return cell
    }
    
    func updateUI(with services: [Service]) {
        DispatchQueue.main.async {
            self.services = services
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToServiceDetail" {
            let indexPath = tableView.indexPathForSelectedRow
            
            let index = indexPath?.row
            
            let detailViewController = segue.destination as! ServiceDetailViewController
            
            detailViewController.serviceId = services[index!].id
            detailViewController.serviceName = services[index!].name
        }
    }

}
