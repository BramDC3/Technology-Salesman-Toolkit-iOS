import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        if registrationFormIsValid() {
            
            // https://firebase.google.com/docs/auth/ios/custom-auth
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                
                guard (authResult?.user) != nil else {
                    self.displayAlert(withMessage: "Er is iets fout gegaan tijdens het aanmaken van het account.")
                    return
                }
                
                // https://stackoverflow.com/questions/38389341/firebase-create-user-with-email-password-display-name-and-photo-url
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = "\(self.firstnameTextField.text!) \(self.lastnameTextField.text!)"
                
                changeRequest?.commitChanges { error in
                    if let error = error {
                        print("Error committing change request: %@", error)
                    } else {
                        authResult?.user.sendEmailVerification()
                        self.displayAlert(withMessage: "Uw account werd succesvol aangemaakt en er werd een bevestigingsmail naar uw e-mailadres verzonden.")
                    }
                }
                
            }
        }
    }
    
    // Function that checks whether all fields of the form are filled in correctly
    private func registrationFormIsValid() -> Bool {
        guard let firstname = firstnameTextField.text, let lastname = lastnameTextField.text,  let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text, firstname != "", lastname != "",  email != "", password != "", repeatPassword != "" else {
            self.displayAlert(withMessage: "Gelieve alle velden in te voeren.")
            return false
        }
        
        guard isValid(email: email) else {
            self.displayAlert(withMessage: "Gelieve een geldig e-mailadres in te voeren.")
            return false
        }
        
        guard password.count >= 6 else {
            self.displayAlert(withMessage: "Het wachtwoord moet minstens 6 karakters lang zijn.")
            return false
        }
        
        guard password == repeatPassword else {
            self.displayAlert(withMessage: "De twee opgegeven wachtwoorden komen niet overeen.")
            return false
        }
        
        return true
    }
    
    // Function that checks whether the provided email address is valid or not
    // https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    private func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Function for displaying alerts with the given message
    private func displayAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Account aanmaken", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
