//
//  DeepLinkHandler.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/6/25.
//

// New File: DeepLinkHandler.swift (or similar)
import SwiftUI
import BranchSDK

@Observable
class DeepLinkHandler { // ⚠️ No longer conforms to BranchSessionDelegate
    var showingDeepLinkMonsterDetail: Bool = false
    var deepLinkMonsterImage: String = ""
    var deepLinkMonsterName: String = ""

    // The function that processes the data
    func handleDeepLinkDisplay(sessionParams: [AnyHashable: Any]?) {
        print("Inside DeepLinkHandler.handleDeepLinkDisplay")
        
        let safeSessionParams = sessionParams ?? [AnyHashable: Any]()
        
        // Corrected guard let logic (from previous step)
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
        
        // 2. Extract Data
        // NOTE: Assuming MonsterImages.shared is available here
        let assetName = MonsterImages.shared.getDeeplinkImage(params: safeSessionParams as NSDictionary)
        let name = (safeSessionParams["monster_name"] as? String) ?? "Mysterious Monster"
        
        if !assetName.isEmpty {
            DispatchQueue.main.async {
                 // 3. Update State variables
                self.deepLinkMonsterImage = assetName
                self.deepLinkMonsterName = name
                self.showingDeepLinkMonsterDetail = true
                print("Deep Link found and state updated: \(name) (\(assetName))")
            }
        }
    }
}
