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
        FirestoreAPI.fetchServices() { (services) in
            if let services = services {
                self.updateUI(with: services)
            }
        }
    }
    
    // The number of sections, 1 is default but I want to clearly define this table view
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return services.count }
        else { return 0 }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        let service = services[indexPath.row]

        cell.logoImageView.downloaded(from: service.image)
        
        cell.titleLabel.text = service.name
        cell.descriptionLabel.text = service.description
        cell.categoryLabel.text = "\(service.category)"
        cell.priceLabel.text = service.price == 0.0 ? " " : String(format: "€ %.2f", service.price)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToServiceDetail", sender: indexPath);
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
