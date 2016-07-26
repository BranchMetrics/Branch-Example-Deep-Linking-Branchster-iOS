#Create a personal copy of the Branchsters app for testing!

1. Clone the repo: git clone https://github.com/BranchMetrics/Branch-Example-Deep-Linking-Branchster-iOS.git
2. cd Branch-Example-Deep-Linking-Branchster-iOS/
3. pod install
4. In finder, open: BranchMonsterFactory.xcworkspace
5. In Xcode, click on the root node of the project: BranchMonsterFactory
6. Under Targets select the BranchMonsterFactory and the General tab
7. Change the Bundle Identifier to something unique (I chose "io.branch.Objective-C.Branchsters")
8. Change the Team to your Team and click Fix Issue
9. On the Branch dashboard, create a new app and copy the key (key_live_aof272VF10ngoViOQqEgGfliDwiKLK1G)
10. In info.plist change the branch_key to the value of the new key
11. Add a new String key to the info.plist file: branch_app_domain
12. Populate the new branch_app_domain key with the value of the "Default domain name" field found in the Custom Link Domain section of the dashboard's Link Settings tab (I got kbbv.app.link)
13. In the Branchsters.entitlements file add entries for the new Branch Live and Test link domains. For kbbv.app.link this would be: applinks:kbbv.app.link; applinks:kbbv.test-app.link; applinks:kbbv-alternate.app.link; applinks:kbbv-alternate.test-app.link
14. Run the app and make sure that it launches properly on a device or on a simulator
15. Populate the Branch dashboard with the following values:
- Always try to open app: Checked
- I have an iOS App: Checked
- iOS URL: branchsters:// (from the info.plist file this is URL Types > URL Schemes > Item 0)
- Custom URL: (enter a web site here if you haven't published the app to the App Store - http://www.branch.io, for example)
- Bundle Identifier: as set in the project above (in this example: io.branch.Objective-C.Branchsters)
- Apple App Prefix: (find this in the Apple developer dashboard: https://developer.apple.com/account/ios/identifier/bundle)
- Default URL: (any web site will do: http://www.branch.io, for example)
- Save

Test:
1. If the app was installed on the test device already, delete the app from the device; clear Safari web content, history and cookies; and reset the devices IDFA (Settings > Privacy > Advertising > Reset Advertising Identifier...)
2. Create a Marketing link
3. Paste the link into Notes on an iPhone
4. Tap the link - you will get redirected to the web page
5. Install the app on the device
6. Tapping on the link should now open the app directly
