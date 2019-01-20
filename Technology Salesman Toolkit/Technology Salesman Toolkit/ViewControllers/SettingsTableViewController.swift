import UIKit

/// View containing all settings of the app and useful information about the app.
class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Called when a row of the table view is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath.row
        if indexPath.section == 1 {
            index += 1
        }
        
        switch index {
            case 0: displaySignOutAlert()
            case 1: displaySendSuggestionAlert()
            case 2: WebsiteUtils.openWebsite(withLink: StringConstants.privacyPolicy)
            case 3: WebsiteUtils.openWebsite(withLink: StringConstants.website)
            default: fatalError("The selected action doesn't exist.")
        }
    }
    
    /// Display the sign out alert.
    private func displaySignOutAlert() {
        let alert = AlertUtils.createFunctionalAlert(withTitle: StringConstants.titleSettingsSignOutAlert, andMessage: StringConstants.messageSignOut, andFunction: {
            FirebaseUtils.signOut()
            self.present(FirebaseUtils.navigateToLoginView(), animated: true, completion: nil)
        })
        self.present(alert, animated: true)
    }
    
    /// Display the send suggestion alert.
    private func displaySendSuggestionAlert() {
        let alert = AlertUtils.createSendSuggestionAlert(withTitle: StringConstants.titleSettingsSendSuggestionAlert, andMessage: StringConstants.messageSendSuggestion, andFunction: { (suggestion) in
            self.sendSuggestion(suggestion)
        })
        self.present(alert, animated: true)
    }
    
    /**
     Post a suggestion the user entered to the Firestore.
     
     - Parameter suggestion: Suggestion of the user.
     */
    private func sendSuggestion(_ suggestion: String) {
        guard !suggestion.isEmpty else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleSettingsSendSuggestionAlert, andMessage: StringConstants.errorEmptySuggestion)
            self.present(alert, animated: true)
            return
        }
        
        FirestoreAPI.instance.postSuggestion(suggestion) { (succes) in
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleSettingsSendSuggestionAlert, andMessage: succes ? StringConstants.successSendSuggestion : StringConstants.errorSuggestionNotSent)
            self.present(alert, animated: true)
        }
    }

}
