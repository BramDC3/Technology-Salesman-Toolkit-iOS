import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) { displayPrivacyPolicyAlert() }
    
    private func displayPrivacyPolicyAlert() {
        guard isRegistrationFormValid() else { return }
        
        let alert = AlertUtils.createPrivacyPolicyAlert(withTitle: StringConstants.privacyPolicyAlert, andMessage: StringConstants.messagePrivacyPolicy, andFunction: createAccount)
        self.present(alert, animated: true, completion: nil)
    }
    
    // https://firebase.google.com/docs/auth/ios/custom-auth
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
    
    // Function that checks whether all fields of the form are filled in correctly
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
