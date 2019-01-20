import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private var editable: Bool = false

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
        
        if let link = FirebaseUtils.firebaseUser?.photoURL {
            FirebaseUtils.fetchImage(with: link) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.profilePictureImageView.image = image
                }
            }
        } else {
            self.profilePictureImageView.image = #imageLiteral(resourceName: "default_profile_image")
        }
        
        updateUI()
    }
    
    @IBAction func toggleEditModeButtonTapped(_ sender: UIBarButtonItem) { toggleEditMode() }
    @IBAction func editProfileButtonTapped(_ sender: UIButton) { displayEditProfileDialog() }
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) { displayChangePasswordAlert() }
    
    private func updateUI() {
        fullnameLabel.text = FirebaseUtils.firebaseUser?.displayName
        firstnameTextField.text = StringUtils.getFirstname(from: FirebaseUtils.firebaseUser?.displayName)
        lastnameTextField.text = StringUtils.getLastname(from: FirebaseUtils.firebaseUser?.displayName)
        emailTextField.text = FirebaseUtils.firebaseUser?.email
    }
    
    private func toggleEditMode() {
        editable = !editable
        
        firstnameTextField.isEnabled = editable
        lastnameTextField.isEnabled = editable
        emailTextField.isEnabled = editable
        
        editProfileButton.isHidden = !editable
        changePasswordButton.isHidden = editable
        
        if !editable {
            updateUI()
        }
    }
    
    private func isProfileFormValid() -> Bool {
        guard let firstname = firstnameTextField.text, let lastname = lastnameTextField.text, let email = emailTextField.text else { return false }
        
        guard ValidationUtils.everyFieldHasValue([firstname, lastname, email]) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.formEmptyFields)
            self.present(alert, animated: true, completion: nil)
            return false
        }
    
        guard FirebaseUtils.firebaseUser!.displayName! != "\(firstname) \(lastname)" || FirebaseUtils.firebaseUser!.email! != email else {
            toggleEditMode()
            return false
        }
        
        guard ValidationUtils.isEmailValid(email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.formInvalidEmailAddress)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    private func displayEditProfileDialog() {
        if isProfileFormValid() {
            let alert = AlertUtils.createFunctionalAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.messageEditProfile, andFunction: {
                self.checkForProfileChanges()
            })
            self.present(alert, animated: true)
        }
    }
    
    private func checkForProfileChanges() {
        let name = "\(firstnameTextField.text!) \(lastnameTextField.text!)"
        if (FirebaseUtils.firebaseUser!.displayName! != name) {
            changeName(to: name)
        }
        
        let email = emailTextField.text!
        if (FirebaseUtils.firebaseUser!.email != email) {
            changeEmail(to: email)
        }
    }
    
    private func changeName(to name: String) {
        let changeRequest = FirebaseUtils.firebaseUser!.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges { (error) in
            if error != nil {
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.errorNameNotChanged)
                self.present(alert, animated: true, completion: nil)
                print("Error committing change request: %@", error!)
            } else {
                self.updateUI()
                if self.editable { self.toggleEditMode() }
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.successNameChange)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func changeEmail(to email: String) {
        FirebaseUtils.firebaseUser!.updateEmail(to: email) { (error) in
            guard error == nil else {
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.errorEmailAddressNotChanged)
                self.present(alert, animated: true, completion: nil)
                print("Error committing change request: %@", error!)
                return
            }
            
            FirebaseUtils.firebaseUser!.sendEmailVerification() { (error) in
                if error == nil {
                    FirebaseUtils.signOut()
                    self.present(FirebaseUtils.navigateToLoginView(), animated: true, completion: nil)
                } else {
                    let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.errorEmailAddressNotChanged)
                    self.present(alert, animated: true, completion: nil)
                    print("Error committing change request: %@", error!)
                }
            }
        }
    }
    
    private func displayChangePasswordAlert() {
        let alert = AlertUtils.createFunctionalAlert(withTitle: StringConstants.titleProfileChangePasswordAlert, andMessage: StringConstants.messageChangePassword, andFunction: {
            self.sendResetPasswordEmail()
        })
        self.present(alert, animated: true)
    }
    
    private func sendResetPasswordEmail() {
        FirebaseUtils.mAuth.sendPasswordReset(withEmail: FirebaseUtils.firebaseUser!.email!) { (error) in
            if error == nil {
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileChangePasswordAlert, andMessage: StringConstants.messageChangePasswordEmailSent)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = AlertUtils.createSimpleAlert(withTitle: StringConstants.titleProfileChangePasswordAlert, andMessage: StringConstants.errorChangePasswordEmailNotSent)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
