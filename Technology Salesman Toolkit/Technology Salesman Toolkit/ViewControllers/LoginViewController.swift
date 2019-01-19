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
    
    @IBAction func signInButtonTapped(_ sender: UIButton) { signIn() }
    
    // Function for signing the user in with an email/password combination
    // https://firebase.google.com/docs/auth/ios/custom-auth
    private func signIn() {
        guard loginFormIsValid() else { return }
        
        FirebaseUtils.mAuth.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            guard let user = user else {
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleLoginAlert, andMessage: StringConstants.errorUnexpected)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard user.user.isEmailVerified else {
                FirebaseUtils.signOut()
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleLoginAlert, andMessage: StringConstants.formUnverifiedEmailAddress)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            FirebaseUtils.firebaseUser = user.user
            self.present(FirebaseUtils.navigateToServiceTableView(), animated: true, completion: nil)
        }
    }
    
    // Function that checks whether all fields of the form are filled in correctly
    private func loginFormIsValid() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return false }
        
        guard ValidationUtils.doesEveryFieldHaveValue(fields: [email, password]) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleLoginAlert, andMessage: StringConstants.formEmptyFields)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard ValidationUtils.isEmailValid(email: email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleLoginAlert, andMessage: StringConstants.formInvalidEmailAddress)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // Function for going back to the login screen
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) { }
    
}
