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
            displaySendSuggestionAlert()
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
        let alert = AlertUtils.createFunctionalAlert(withTitle: StringConstants.titleSettingsSignOutAlert, andMessage: StringConstants.messageSignOut, andFunction: {
            FirebaseUtils.signOut()
            FirebaseUtils.navigateToLogin()
        })
        self.present(alert, animated: true)
    }
    
    private func displaySendSuggestionAlert() {
        let alert = AlertUtils.createSendSuggestionAlert(withTitle: StringConstants.titleSettingsSendSuggestionAlert, andMessage: StringConstants.messageSendSuggestion, andFunction: { (message) in
            self.sendSuggestion(withMessage: message)
        })
        self.present(alert, animated: true)
    }
    
    private func sendSuggestion(withMessage message: String) {
        guard !message.isEmpty else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleSettingsSendSuggestionAlert, andMessage: StringConstants.errorEmptySuggestion)
            self.present(alert, animated: true)
            return
        }
        
        FirestoreAPI.postSuggestion(withMessage: message) { (succes) in
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleSettingsSendSuggestionAlert, andMessage: succes ? StringConstants.successSendSuggestion : StringConstants.errorSuggestionNotSent)
            self.present(alert, animated: true)
        }
    }

}
