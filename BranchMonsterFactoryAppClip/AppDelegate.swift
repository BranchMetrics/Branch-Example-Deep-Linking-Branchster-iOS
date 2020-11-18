//
//  AppDelegate.swift
//  BranchMonsterFactoryAppClip
//
//  Created by Ernest Cho on 10/8/20.
//  Copyright © 2020 Branch. All rights reserved.
//

import UIKit
import Branch

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BNCLogSetDisplayLevel(BNCLogLevel.all);
        
        // fallback if we're offline
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if (Monster.shared.waitingForData) {
                Monster.shared.update(name: "Branchster", text: "", face: 0, body: 0, color: 0)
            }
        }
        
        Branch.getInstance().setAppClipAppGroup("group.io.branch")
        BranchScene.shared().initSession(launchOptions: launchOptions) { (params, error, scene) in
            if let dict = params {
                
                // update to monster in branch payload, or fallack monster
                if (Monster.shared.waitingForData) {
                    let name = (dict["monster_name"] as? String) ?? "Branchster"
                    let text = (dict["$og_description"] as? String) ?? ""
                    let face = Int(dict["face_index"] as? String ?? "0") ?? 0
                    let body = Int(dict["body_index"] as? String ?? "0") ?? 0
                    let color = Int(dict["color_index"] as? String ?? "0") ?? 0
                    Monster.shared.update(name: name, text: text, face: face, body: body, color: color)
                }
                
                print(dict.description)
            }
        }
        
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

