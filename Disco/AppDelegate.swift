import UIKit
import HyBid
import GoogleMobileAds
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    let appToken = "543027b8e954474cbcd9a98481622a3b"
    let appStoreID = "1530210244"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        HyBid.initWithAppToken(appToken, completion: nil)

        HyBid.setCoppa(false)
        HyBid.setTestMode(false)
        HyBid.setLocationTracking(true)
        HyBid.setHTMLInterstitialSkipOffset(2)
        HyBid.setVideoInterstitialSkipOffset(5)
        HyBid.setInterstitialActionBehaviour(HB_CREATIVE)
        let targeting = HyBidTargetingModel()
        targeting.age = 28
        targeting.interests = ["music"]
        targeting.gender = "f"     // "f" for female, "m" for male
        HyBid.setTargeting(targeting)
        HyBid.setInterstitialSKOverlay(true)
        HyBid.setRewardedSKOverlay(true)
        HyBidLogger.setLogLevel(HyBidLogLevelDebug)

        FirebaseApp.configure()

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

