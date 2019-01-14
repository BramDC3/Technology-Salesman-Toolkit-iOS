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
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        if registrationFormIsValid() {
            
            // https://firebase.google.com/docs/auth/ios/custom-auth
            FirebaseUtils.mAuth.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                
                guard (authResult?.user) != nil else {
                    let alert = AlertUtils.createSimpleAlert(withTitle: "Account aanmaken", andMessage: "Er is iets fout gegaan tijdens het aanmaken van het account.")
                    self.present(alert, animated: true, completion: nil)
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
                        let alert = AlertUtils.createSimpleAlert(withTitle: "Account aanmaken", andMessage: "Uw account werd succesvol aangemaakt en er werd een bevestigingsmail naar uw e-mailadres verzonden.")
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
    // Function that checks whether all fields of the form are filled in correctly
    private func registrationFormIsValid() -> Bool {
        guard let firstname = firstnameTextField.text, let lastname = lastnameTextField.text,  let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text, firstname != "", lastname != "",  email != "", password != "", repeatPassword != "" else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Account aanmaken", andMessage: "Gelieve alle velden in te voeren.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard ValidationUtils.isEmailValid(email: email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Account aanmaken", andMessage: "Gelieve een geldig e-mailadres in te voeren.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard password.count >= 6 else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Account aanmaken", andMessage: "Het wachtwoord moet minstens 6 karakters lang zijn.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard password == repeatPassword else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Account aanmaken", andMessage: "De twee opgegeven wachtwoorden komen niet overeen.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
}
