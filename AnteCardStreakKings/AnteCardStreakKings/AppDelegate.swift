//
//  AppDelegate.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//

import UIKit
import IQKeyboardManagerSwift
import AdjustSdk

func sandboxArchivePath() -> String {
    let dir : NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let path = dir.appendingPathComponent("solitaireGame.plist")
    return path
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var solitaire : AnteCardSolitaire!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let archiveName = sandboxArchivePath()
        if FileManager.default.fileExists(atPath: archiveName) {
            let dict = NSDictionary(contentsOfFile: archiveName) as! [String : AnyObject]
            solitaire = AnteCardSolitaire(dictionary: dict)
        } else {
            solitaire = AnteCardSolitaire()
            solitaire.freshGame()
        }
        
        IQKeyboardManager.shared.isEnabled = true
        
        initAdjustConfig(token: "gz7i30jtpk3k")
        return true
    }
    
    private func initAdjustConfig(token: String) {
        let environment = ADJEnvironmentProduction
        let myAdjustConfig = ADJConfig(
               appToken: token,
               environment: environment)
        myAdjustConfig?.logLevel = ADJLogLevel.verbose
        Adjust.initSdk(myAdjustConfig);
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

