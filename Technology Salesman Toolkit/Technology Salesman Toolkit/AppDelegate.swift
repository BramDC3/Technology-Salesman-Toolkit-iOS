import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Configuring the app to work with Firebase.
        /// SOURCE: https://firebase.google.com/docs/auth/ios/start
        FirebaseApp.configure()
        
        /// Firestore settings to use Timestamps instead of Date objects.
        /// SOURCE: https://stackoverflow.com/a/51880479
        let settings = Firestore.firestore().settings
        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        
        /// Adding cache for storing images: 25 MB of memory and 50 MB of disk space
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25000000, diskCapacity: 50000000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        /// Used for signing in with a Google account.
        /// SOURCE: https://firebase.google.com/docs/auth/ios/google-signin
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        /// Checking whether the user is signed in or not.
        /// If not, they are redirected to the login view.
        if FirebaseUtils.firebaseUser == nil || !FirebaseUtils.firebaseUser!.isEmailVerified {
            let rootController = UIStoryboard(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = rootController
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// Used for signing in with a Google account.
    /// SOURCE: https://firebase.google.com/docs/auth/ios/google-signin
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    /// Used for creating a Firebase account with a Google account.
    /// SOURCE: https://firebase.google.com/docs/auth/ios/google-signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        FirebaseUtils.mAuth.signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            
            // User is signed in
            if let authResult = authResult {
                self.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
                FirebaseUtils.firebaseUser = authResult.user
            }
        }
    }
    
}
