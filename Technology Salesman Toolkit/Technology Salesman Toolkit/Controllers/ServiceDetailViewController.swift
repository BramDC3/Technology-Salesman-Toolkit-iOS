//
//  ServiceDetailViewController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 11/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController {
    
    var serviceId: String!
    var instructions: [Instruction] = []
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceLabel.text = ("id: \(serviceId!)")
        
        FirestoreAPI.fetchInstructions(fromService: serviceId) { (instructions) in
            if let instructions = instructions {
                self.updateUI(with: instructions)
            }
        }
    }
    
    func updateUI(with instructions: [Instruction]) {
        DispatchQueue.main.async {
            self.instructions = instructions
            
            instructions.forEach { instruction in
                print(instruction.title)
            }
        }
    }

}
