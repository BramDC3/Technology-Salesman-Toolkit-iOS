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
            do {
                try FirebaseUtils.mAuth.signOut()
                FirebaseUtils.firebaseUser = nil
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }

            let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
            appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
        case 1:
            print(1)
        case 2:
            print(2)
        case 3:
            if let link = URL(string: "https://technology-salesman-toolkit.firebaseapp.com/privacy_policy.html") {
                UIApplication.shared.open(link)
            }
        case 4:
            if let link = URL(string: "https://bramdeconinck.com") {
                UIApplication.shared.open(link)
            }
        default:
            print("foutje")
        }
    }

}
