//
//  FirebaseUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 07/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import Foundation
import FirebaseAuth

struct FirebaseUtils {
    
    static let mAuth = Auth.auth()
    static var firebaseUser = mAuth.currentUser
    
    static func convertIntToCategory(int: Int) -> Category {
        switch int {
            case 0: return Category.Windows
            case 1: return Category.Android
            case 2: return Category.Apple
            default: return Category.Andere
        }
    }
    
    static func signOut() {
        do {
            try mAuth.signOut()
            firebaseUser = nil
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func navigateToLogin() {
        let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
        appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
    }
    
    static func navigateToServiceTableView() {
        let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
        appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
    }
    
}
