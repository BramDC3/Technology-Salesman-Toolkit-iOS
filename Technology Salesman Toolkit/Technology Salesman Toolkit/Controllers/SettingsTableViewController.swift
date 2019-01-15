//
//  SettingsTableViewController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 04/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath.row
        if indexPath.section == 1 {
            index += 2
        }
        
        switch index {
        case 0:
            displaySignOutAlert()
        case 1:
            print(1)
        case 2:
            print(2)
        case 3:
            if let link = URL(string: StringConstants.privacyPolicy) {
                UIApplication.shared.open(link)
            }
        case 4:
            if let link = URL(string: StringConstants.website) {
                UIApplication.shared.open(link)
            }
        default:
            fatalError("The selected action doesn't exist.")
        }
    }
    
    private func displaySignOutAlert() {
        let alert = UIAlertController(title: StringConstants.titleSettingsSignOutAlert, message: StringConstants.messageSignOut, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.alertNo, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.alertYes, style: .default, handler: { action in
            FirebaseUtils.signOut()
            FirebaseUtils.navigateToLogin()
        }))
        self.present(alert, animated: true)
    }

}
