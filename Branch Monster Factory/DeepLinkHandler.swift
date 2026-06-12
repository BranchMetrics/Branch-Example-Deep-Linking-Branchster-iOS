//
//  DeepLinkHandler.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/6/25.
//

import SwiftUI
import BranchSDK

@Observable
class DeepLinkHandler {
    var showingDeepLinkMonsterDetail: Bool = false
    var deepLinkMonsterImage: String = ""
    var deepLinkMonsterName: String = ""

    func handleDeepLinkDisplay(sessionParams: [AnyHashable: Any]?) {
        print("Inside DeepLinkHandler.handleDeepLinkDisplay")
        
        let safeSessionParams = sessionParams ?? [AnyHashable: Any]()
        
        guard let clickedValue = safeSessionParams["+clicked_branch_link"] else {
            print("Branch flag not present.")
            return
        }
        
        let wasBranchLinkClicked: Bool
        if let clickedBool = clickedValue as? Bool {
            wasBranchLinkClicked = clickedBool
        } else if let clickedString = clickedValue as? String {
            wasBranchLinkClicked = (clickedString == "true")
        } else {
            print("Session not initiated by a Branch link click or flag is false.")
            return
        }

        guard wasBranchLinkClicked else {
            return
        }
        
        let assetName = MonsterImages.shared.getDeeplinkImage(params: safeSessionParams as NSDictionary)
        let name = (safeSessionParams["monster_name"] as? String) ?? "Mysterious Monster"
        
        if !assetName.isEmpty {
            DispatchQueue.main.async {
                self.deepLinkMonsterImage = assetName
                self.deepLinkMonsterName = name
                self.showingDeepLinkMonsterDetail = true
                print("Deep Link found and state updated: \(name) (\(assetName))")
            }
        }
    }
}
