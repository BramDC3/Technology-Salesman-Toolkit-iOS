//
//  ProfileViewController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 12/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

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
        
        if let image = FirebaseUtils.firebaseUser?.photoURL {
            profilePictureImageView.downloaded(from: image)
        }
        
        updateUI()
    }
    
    private func updateUI() {
        fullnameLabel.text = FirebaseUtils.firebaseUser?.displayName
        
        firstnameTextField.text = StringUtils.getFirstname(fullname: FirebaseUtils.firebaseUser?.displayName)
        
        lastnameTextField.text = StringUtils.getLastname(fullname: FirebaseUtils.firebaseUser?.displayName)
        
        emailTextField.text = FirebaseUtils.firebaseUser?.email
    }
    
    @IBAction func toggleEditModeButtonClicked(_ sender: UIBarButtonItem) { toggleEditMode() }
    
    @IBAction func editProfileButtonClicked(_ sender: UIButton) { displayEditProfileDialog() }
    
    @IBAction func changePasswordButtonClicked(_ sender: UIButton) { displayChangePasswordAlert() }
    
    private func toggleEditMode() {
        editable = !editable
        
        firstnameTextField.isEnabled = editable
        lastnameTextField.isEnabled = editable
        emailTextField.isEnabled = editable
        
        editProfileButton.isHidden = !editable
        changePasswordButton.isHidden = editable
        
        if !editable { updateUI() }
    }
    
    private func profileFormIsValid() -> Bool {
        guard let firstname = firstnameTextField.text, let lastname = lastnameTextField.text,  let email = emailTextField.text, firstname != "", lastname != "", email != "" else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Profiel wijzigen", andMessage: "Gelieve alle velden in te voeren.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard FirebaseUtils.firebaseUser!.displayName! != "\(firstname) \(lastname)" || FirebaseUtils.firebaseUser!.email! != email else {
            toggleEditMode()
            return false
        }
        
        guard ValidationUtils.isEmailValid(email: email) else {
            let alert = AlertUtils.createSimpleAlert(withTitle: "Profiel wijzigen", andMessage: "Gelieve een geldig e-mailadres in te voeren.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    private func displayEditProfileDialog() {
        if profileFormIsValid() {
            let alert = UIAlertController(title: "Profiel wijzigen", message: "Bent u zeker dat u uw profiel wilt wijzigen?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Nee", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
                self.checkForProfileChanges()
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    private func checkForProfileChanges() {
        let name = "\(firstnameTextField.text!) \(lastnameTextField.text!)"
        
        if (FirebaseUtils.firebaseUser!.displayName! != name) { changeName(to: name) }
        
        let email = emailTextField.text!
        
        if (FirebaseUtils.firebaseUser!.email != email) { changeEmail(to: email) }
    }
    
    private func changeName(to name: String) {
        let changeRequest = FirebaseUtils.firebaseUser!.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges { error in
            if error != nil {
                let alert = AlertUtils.createSimpleAlert(withTitle: "Profiel wijzigen", andMessage: "Er is een onverwachte fout opgetreden tijdens het wijzigen van uw naam.")
                self.present(alert, animated: true, completion: nil)
                print("Error committing change request: %@", error!)
            } else {
                self.updateUI()
                if self.editable { self.toggleEditMode() }
                let alert = AlertUtils.createSimpleAlert(withTitle: "Profiel wijzigen", andMessage: "Uw naam werd succesvol gewijzigd.")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func changeEmail(to email: String) {
        FirebaseUtils.firebaseUser!.updateEmail(to: email) { error in
            guard error == nil else {
                let alert = AlertUtils.createSimpleAlert(withTitle: "Profiel wijzigen", andMessage: "Er is een onverwachte fout opgetreden tijdens het wijzigen van uw e-mailadres.")
                self.present(alert, animated: true, completion: nil)
                print("Error committing change request: %@", error!)
                return
            }
            
            FirebaseUtils.firebaseUser!.sendEmailVerification() { error in
                if error == nil {
                    do {
                        try FirebaseUtils.mAuth.signOut()
                        FirebaseUtils.firebaseUser = nil
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    
                    let alert = AlertUtils.createSimpleAlert(withTitle: "Profiel wijzigen", andMessage: "Uw e-mailadres werd succesvol gewijzigd.")
                    self.present(alert, animated: true, completion: nil)
                    
                    let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
                    appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
                } else {
                    let alert = AlertUtils.createSimpleAlert(withTitle: "Profiel wijzigen", andMessage: "Er is een onverwachte fout opgetreden tijdens het wijzigen van uw e-mailadres.")
                    self.present(alert, animated: true, completion: nil)
                    print("Error committing change request: %@", error!)
                }
            }
        }
    }
    
    private func displayChangePasswordAlert() {
        let alert = UIAlertController(title: "Wachtwoord wijzigen", message: "Bent u zeker dat u uw wachtwoord wilt wijzigen? Als u op 'Ja' drukt, zal er een e-mail verzonden worden waarmee uw wachtwoord opnieuw ingesteld kan worden.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nee", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            self.sendResetPasswordEmail()
        }))
        
        self.present(alert, animated: true)
    }
    
    private func sendResetPasswordEmail() {
        FirebaseUtils.mAuth.sendPasswordReset(withEmail: FirebaseUtils.firebaseUser!.email!) { error in
            if error == nil {
                let alert = AlertUtils.createSimpleAlert(withTitle: "Wachtwoord wijzigen", andMessage: "Er werd een e-mail verzonden naar uw e-mailadres waarmee u uw wachtwoord kunt wijzigen.")
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = AlertUtils.createSimpleAlert(withTitle: "Wachtwoord wijzigen", andMessage: "Er is een onverwachte fout opgetreden tijdens het versturen van de mail voor het wijzigen van uw wachtwoord.")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
