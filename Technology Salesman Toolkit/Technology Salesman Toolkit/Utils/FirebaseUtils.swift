import Foundation
import FirebaseAuth
import RealmSwift

/// Utilities used by functions related to the Firebase.
struct FirebaseUtils {
    
    /// Used to manage Firebase authentication
    static let mAuth = Auth.auth()
    
    /// The currently user, if he/she is signed in.
    static var firebaseUser = mAuth.currentUser
    
    /**
     Converting an integer to its corresponding category.
     
     - Parameter int: Integer that needs to be converted.
     
     - Returns: The category corresponding to the integer.
     */
    static func convertToCategory(_ int: Int) -> Category {
        switch int {
            case 0: return Category.windows
            case 1: return Category.android
            case 2: return Category.apple
            default: return Category.other
        }
    }
    
    /**
     Converting an array of strings to a list of string.
     
     - Parameter array: Array of strings that needs to be converted.
     
     - Returns: List of strings coming from the array.
     */
    static func convertToList(_ array: [String]) -> List<String> {
        let list = List<String>()
        list.append(objectsIn: array)
        return list
    }
    
    /**
     Fetching an image from the internet.
     
     - Parameters:
        - url: Link to the image that needs to be fetched.
        - completion: Function that needs to be executed when
                      the image is fetched or an error occurred
                      during the fetching.
     */
    static func fetchImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    /// Signing the currently signed in user out.
    static func signOut() {
        do {
            try mAuth.signOut()
            firebaseUser = nil
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    /// Navigating to the login view.
    static func navigateToLoginView() -> UIViewController {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
    
    /// Navigating to the service table view.
    static func navigateToServiceTableView() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
    
}
