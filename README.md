## Create a personal copy of the Branchsters app for testing!

1. From the command line:  
  - Clone the repo: git clone https://github.com/BranchMetrics/Branch-Example-Deep-Linking-Branchster-iOS.git  
  - cd Branch-Example-Deep-Linking-Branchster-iOS/  
  - pod install
2. In finder open: BranchMonsterFactory.xcworkspace
3. In Xcode click on the root node of the project: BranchMonsterFactory
4. Under Targets select BranchMonsterFactory, then the General tab
5. Change the Bundle Identifier to something unique (for this demo we'll use "io.branch.Objective-C.Branchsters")
6. Change the Team to your Team and click Fix Issue
7. Log in to the Branch dashboard and create a new app
8. On the Settings screen copy the key (for this demo: key_live_aof272VF10ngoViOQqEgGfliDwiKLK1G)
9. In the Xcode project's info.plist file change the branch_key to the value of the new key
10. Add a new String key to the info.plist file: branch_app_domain
11. Populate the new branch_app_domain key with the value of the "Default domain name" field found in the Custom Link Domain section of the dashboard's Link Settings tab (for this demo: kbbv.app.link)
12. In the Branchsters.entitlements file add entries for the new Branch Live and Test link domains. For kbbv.app.link this would be:
 - applinks:kbbv.app.link
 - applinks:kbbv.test-app.link
 - applinks:kbbv-alternate.app.link
 - applinks:kbbv-alternate.test-app.link
13. Run the app and make sure that it launches properly on a device or on a simulator
14. Populate the Branch dashboard with the following values:
 - Always try to open app: Checked
 - I have an iOS App: Checked
 - iOS URL: branchsters:// (from the info.plist file this is URL Types > URL Schemes > Item 0)
 - Custom URL: (enter a web site here if you haven't published the app to the App Store - http://www.branch.io, for example)
 - Bundle Identifier: as set in the project above (in this example: io.branch.Objective-C.Branchsters)
 - Apple App Prefix: (find this in the Apple developer dashboard: https://developer.apple.com/account/ios/identifier/bundle)
 - Default URL: (any web site will do: http://www.branch.io, for example)
15. Save the settings - you are done!

### Test
1. If the app was installed on the test device already:
 - Delete the app from the device
 - Clear Safari web content, history and cookies (Settings > Safari > Clear History and Website Data)
 - Reset the device's IDFA (Settings > Privacy > Advertising > Reset Advertising Identifier...)
2. Create a Marketing link
3. Paste the link into Notes on an iPhone
4. Tap the link - you will get redirected to the web page
5. Install the app on the device
6. Tapping on the link should now open the app directly
