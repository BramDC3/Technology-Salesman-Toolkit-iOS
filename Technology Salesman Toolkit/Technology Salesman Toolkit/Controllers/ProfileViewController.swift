//
//  ProfileViewController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 12/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
        profilePictureImageView.clipsToBounds = true
        
        if let image = FirebaseUtils.firebaseUser?.photoURL {
            profilePictureImageView.downloaded(from: image)
        }
        
        fullnameLabel.text = FirebaseUtils.firebaseUser?.displayName
        
        firstnameTextField.text = StringUtils.getFirstname(fullname: FirebaseUtils.firebaseUser?.displayName)
        
        lastnameTextField.text = StringUtils.getLastname(fullname: FirebaseUtils.firebaseUser?.displayName)
        
        emailTextField.text = FirebaseUtils.firebaseUser?.email
    }

}
