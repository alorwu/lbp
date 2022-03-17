import UIKit
import OneSignal
import Firebase

//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//      // Remove this method to stop OneSignal Debugging
////      OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
//
//      // OneSignal initialization
//      OneSignal.initWithLaunchOptions(launchOptions, appId: "a973f3e2-37d5-4377-9e80-196fe7fa9d70")
//
////      FirebaseApp.configure()
//
//      // promptForPushNotifications will show the native iOS notification permission prompt.
//      // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
////      OneSignal.promptForPushNotifications(userResponse: { accepted in
////        print("User accepted notifications: \(accepted)")
////      })
//
//       return true
//    }
//}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    
    OneSignal.initWithLaunchOptions(launchOptions, appId: "a973f3e2-37d5-4377-9e80-196fe7fa9d70")
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
