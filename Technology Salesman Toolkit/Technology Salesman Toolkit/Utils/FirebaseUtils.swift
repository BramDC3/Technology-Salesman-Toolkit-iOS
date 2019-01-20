import Foundation
import FirebaseAuth

struct FirebaseUtils {
    
    static let mAuth = Auth.auth()
    static var firebaseUser = mAuth.currentUser
    
    static func convertToCategory(_ int: Int) -> Category {
        switch int {
            case 0: return Category.windows
            case 1: return Category.android
            case 2: return Category.apple
            default: return Category.other
        }
    }
    
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
    
    static func signOut() {
        do {
            try mAuth.signOut()
            firebaseUser = nil
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func navigateToLoginView() -> UIViewController {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
    
    static func navigateToServiceTableView() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
    
}
