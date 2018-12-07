import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://firebase.google.com/docs/auth/ios/google-signin
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    // Function for signing the user in with an email/password combination
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if loginFormIsValid() {
            
            // https://firebase.google.com/docs/auth/ios/custom-auth
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if let user = user {
                    
                    guard user.user.isEmailVerified else {
                        
                        // https://firebase.google.com/docs/auth/ios/custom-auth
                        do {
                            try Auth.auth().signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                        
                        let alert = AlertUtils.createSimpleAlert(withTitle: "Gelieve alle velden in te voeren.", andMessage: "Gelieve uw e-mailadres eerst te verifiëren aan de hand van de verzonden e-mail.")
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    let alert = AlertUtils.createSimpleAlert(withTitle: "Gelieve alle velden in te voeren.", andMessage: "Welkom \(user.user.displayName!)!")
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    let alert = AlertUtils.createSimpleAlert(withTitle: "Gelieve alle velden in te voeren.", andMessage: "Er is iets fout gegaan tijdens de aanmelding: \(error!)")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Function that checks whether all fields of the form are filled in correctly
    private func loginFormIsValid() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Gelieve alle velden in te voeren.", andMessage: "Gelieve alle velden in te voeren.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard isValid(email: email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Gelieve alle velden in te voeren.", andMessage: "Gelieve een geldig e-mailadres in te voeren.")
            self.present(alert, animated: true, completion: nil)
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
    
    // Function for going back to the login screen
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) { }
    
}
