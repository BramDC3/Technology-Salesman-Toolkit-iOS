import UIKit

/**
 View where users can create an account with an email/password combination.
 
 The Firebase documentation by Google was used as guide
 for everything related to creating an account.
 SOURCE: https://firebase.google.com/docs/auth/ios/custom-auth
 */
class RegistrationViewController: UIViewController {

    /// TextField where users fill in their first name.
    @IBOutlet weak var firstnameTextField: UITextField!
    
    /// TextField where users fill in their last name.
    @IBOutlet weak var lastnameTextField: UITextField!
    
    /// TextField where users fill in their email address.
    @IBOutlet weak var emailTextField: UITextField!
    
    /// TextField where users fill in their password.
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// TextField where users fill in a repition of their password.
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Function executed when the user taps on the create account button.
    @IBAction func createAccountButtonTapped(_ sender: UIButton) { displayPrivacyPolicyAlert() }
    
    /// Displaying the privacy policy alert.
    private func displayPrivacyPolicyAlert() {
        guard isRegistrationFormValid() else { return }
        
        let alert = AlertUtils.createPrivacyPolicyAlert(withTitle: StringConstants.privacyPolicyAlert, andMessage: StringConstants.messagePrivacyPolicy, andFunction: createAccount)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Creating an account with an email/address combination using the data from the form fields.
    private func createAccount() {
        FirebaseUtils.mAuth.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            guard authResult?.user != nil else {
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleRegistrationAlert, andMessage: StringConstants.errorAccountNotCreated)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let changeRequest = authResult?.user.createProfileChangeRequest()
            changeRequest?.displayName = "\(self.firstnameTextField.text!) \(self.lastnameTextField.text!)"
            
            changeRequest?.commitChanges { (error) in
                if let error = error {
                    print("Error committing change request: %@", error)
                } else {
                    authResult?.user.sendEmailVerification()
                    FirebaseUtils.signOut()
                    let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleRegistrationAlert, andMessage: StringConstants.messageVerificationEmailSent)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    /**
     Checking whether the registration form is valid or not
     
     - Returns: Indication whether the registration form is valid or not.
     */
    private func isRegistrationFormValid() -> Bool {
        guard let firstname = firstnameTextField.text, let lastname = lastnameTextField.text,  let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else { return false }
        
        guard ValidationUtils.everyFieldHasValue([firstname, lastname, email, password, repeatPassword]) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleRegistrationAlert, andMessage: StringConstants.formEmptyFields)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard ValidationUtils.isEmailValid(email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleRegistrationAlert, andMessage: StringConstants.formInvalidEmailAddress)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard password.count >= 6 else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleRegistrationAlert, andMessage: StringConstants.formInvalidPassword)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard password == repeatPassword else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleRegistrationAlert, andMessage: StringConstants.formPasswordsDoNotMatch)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
}
