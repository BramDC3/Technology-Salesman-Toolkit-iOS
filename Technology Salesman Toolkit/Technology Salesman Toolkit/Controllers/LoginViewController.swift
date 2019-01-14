import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://firebase.google.com/docs/auth/ios/google-signin
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    // Function for signing the user in with an email/password combination
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if loginFormIsValid() {
            // https://firebase.google.com/docs/auth/ios/custom-auth
            FirebaseUtils.mAuth.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if let user = user {
                    guard user.user.isEmailVerified else {
                        do {
                            try FirebaseUtils.mAuth.signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                        
                        let alert = AlertUtils.createSimpleAlert(withTitle: "Aanmelden", andMessage: "Gelieve uw e-mailadres eerst te verifiëren aan de hand van de verzonden e-mail.")
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    FirebaseUtils.firebaseUser = user.user
                    
                    let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
                    appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
                    
                } else {
                    let alert = AlertUtils.createSimpleAlert(withTitle: "Aanmelden", andMessage: "Er is iets fout gegaan tijdens de aanmelding: \(error!)")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Function that checks whether all fields of the form are filled in correctly
    private func loginFormIsValid() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Aanmelden", andMessage: "Gelieve alle velden in te voeren.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard ValidationUtils.isEmailValid(email: email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Aanmelden", andMessage: "Gelieve een geldig e-mailadres in te voeren.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // Function for going back to the login screen
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) { }
    
}
