import UIKit

// If using iOS SDK 2.0.0+, use the following import:
import BranchSDK

// If using iOS SDK <2.0.0, use the following import:
// import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Listener for Branch deep link data
    Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
      print(params as? [String: AnyObject] ?? {})
      // Access and use deep link data here (nav to page, display content, etc.)
    }
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    Branch.getInstance().application(app, open: url, options: options)
    return true
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    // Handler for Universal Links
    Branch.getInstance().continue(userActivity)
    return true
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Handler for Push Notifications
    Branch.getInstance().handlePushNotification(userInfo)
  }
}
