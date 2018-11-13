import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Function for signing the user in with an email/password combination
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if loginFormIsValid() {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if let user = user {
                    self.displayAlert(withMessage: "Welkom \(user.user.displayName!)!")
                } else {
                    self.displayAlert(withMessage: "Er is iets fout gegaan tijdens de aanmelding: \(error!)")
                }
            }
        }
    }
    
    // Function that checks whether all fields of the form are filled in correctly
    private func loginFormIsValid() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            self.displayAlert(withMessage: "Gelieve alle velden in te voeren.")
            return false
        }
        
        guard isValid(email: email) else {
            self.displayAlert(withMessage: "Gelieve een geldig e-mailadres in te voeren.")
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
        let alert = UIAlertController(title: "Aanmelding", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
