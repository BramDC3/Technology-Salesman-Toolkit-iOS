import UIKit
import FirebaseAuth

/**
 View where users can see their personal information and edit it.
 
 The Firebase documentation by Google was used as guide
 for everything related to editing the account of a user.
 SOURCE: https://firebase.google.com/docs/auth/ios/manage-users
 */
class ProfileViewController: UIViewController {
    
    /// Indication whether 'editing mode' is enabled or not.
    private var editable: Bool = false

    /// Profile picture of the user.
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    /// Full name of the user.
    @IBOutlet weak var fullnameLabel: UILabel!
    
    /// TextField where users fill in their first name.
    @IBOutlet weak var firstnameTextField: UITextField!
    
    /// TextField where users fill in their last name.
    @IBOutlet weak var lastnameTextField: UITextField!
    
    /// TextField where users fill in their email address.
    @IBOutlet weak var emailTextField: UITextField!
    
    /// Button to enter or exit 'editing mode'.
    @IBOutlet weak var editProfileButton: UIButton!
    
    /// Button that is visible in 'editing mode' to apply profile changes.
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
        
        /// SOURCE: App Development with Swift page 949
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
    
    /// Function executed when the user taps on the toggle edit mode button.
    @IBAction func toggleEditModeButtonTapped(_ sender: UIBarButtonItem) { toggleEditMode() }
    
    /// Function executed when the user taps on the edit profile button.
    @IBAction func editProfileButtonTapped(_ sender: UIButton) { displayEditProfileAlert() }
    
    /// Function executed when the user taps on the change password button.
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) { displayChangePasswordAlert() }
    
    /// Filling in the label and textfields with data of the user.
    private func updateUI() {
        fullnameLabel.text = FirebaseUtils.firebaseUser?.displayName
        firstnameTextField.text = StringUtils.getFirstname(from: FirebaseUtils.firebaseUser?.displayName)
        lastnameTextField.text = StringUtils.getLastname(from: FirebaseUtils.firebaseUser?.displayName)
        emailTextField.text = FirebaseUtils.firebaseUser?.email
    }
    
    /// Exiting 'edit mode' when it is entered and vice versa.
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
    
    /**
     Checking whether the profile form is valid or not
     
     - Returns: Indication whether the profile form is valid or not.
     */
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
    
    /// Displaying the edit profile alert.
    private func displayEditProfileAlert() {
        if isProfileFormValid() {
            let alert = AlertUtils.createFunctionalAlert(withTitle: StringConstants.titleProfileEditProfileAlert, andMessage: StringConstants.messageEditProfile, andFunction: {
                self.checkForProfileChanges()
            })
            self.present(alert, animated: true)
        }
    }
    
    /// Checking whether the user has changed their name, email address or both.
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
    
    /**
     Changing the name of the user.
     
     - Parameter name: New name of the user.
     */
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
    
    /**
     Changing the email address of the user.
     
     - Parameter email: New email address of the user.
     */
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
    
    /// Displaying the change password alert.
    private func displayChangePasswordAlert() {
        let alert = AlertUtils.createFunctionalAlert(withTitle: StringConstants.titleProfileChangePasswordAlert, andMessage: StringConstants.messageChangePassword, andFunction: {
            self.sendResetPasswordEmail()
        })
        self.present(alert, animated: true)
    }
    
    /// Sending a reset password email to the user.
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
