import UIKit
import GoogleSignIn

/**
 The first view users see when they aren't signed in. It is
 used to sign in with both an email/password combination
 and Google sign-in.
 
 The Firebase documentation by Google was used as guide
 for everything related to signing in.
 SOURCE: https://firebase.google.com/docs/auth/ios/custom-auth
 SOURCE: https://firebase.google.com/docs/auth/ios/google-signin
 */
class LoginViewController: UIViewController, GIDSignInUIDelegate {

    /// TextField where users fill in their email address.
    @IBOutlet weak var emailTextField: UITextField!
    
    /// TextField where users fill in their password.
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    /// Function executed when the user taps on the sign in button.
    @IBAction func signInButtonTapped(_ sender: UIButton) { signIn() }
    
    /// Signing a user in with their email/password combination.
    private func signIn() {
        guard isLoginFormValid() else { return }
        
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
    
    /**
     Checking whether the login form is valid or not
     
     - Returns: Indication whether the login form is valid or not.
     */
    private func isLoginFormValid() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return false }
        
        guard ValidationUtils.everyFieldHasValue([email, password]) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleLoginAlert, andMessage: StringConstants.formEmptyFields)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard ValidationUtils.isEmailValid(email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleLoginAlert, andMessage: StringConstants.formInvalidEmailAddress)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    /**
     Unwinding to the login view.
     
     - Parameter unwindSeque: Segue that is executed.
     */
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) { }
    
}
