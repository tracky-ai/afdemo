# Tracky - iOS

## Adding tracky.ai to your iOS app

### Add AppsFlyer SDK
AppsFlyer SDK could be added to your app as SPM package dependency. To do so, go to you project settings, Package Dependencies tab and add this package to your target: `Package Dependencies`. If you prefare something else then SPM or need more details, please visit AppsFlyer [Install SDK](https://dev.appsflyer.com/hc/docs/install-ios-sdk) guide.

### Add Tracky code
Add `Tracky.swift` file to your project. You can find it in this example project.

If you are using appDelegate, in `application:didFinishLaunchingWithOptions:` method call `start` method of Tracky class instance.
```code swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Some of your AppDelegate variables
    
    let tracky = Tracky()
    
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Some of your app initialization code
        
        tracky.start { message in
            #if DEBUG
            print(message)
            #endif
        }

    }
    
}
```
This file is provided as an example so fill free to modify this code as needed.

### Update AppsFlyer SDK config 
You will need to update `appsFlyerDevKey` and `appleAppID` parameters of `AppsFlyerLib.shared()` instance before use.
```code swift
AppsFlyerLib.shared().appsFlyerDevKey = "<YOUR_DEV_KEY>"
AppsFlyerLib.shared().appleAppID = "<APPLE_APP_ID>"
AppsFlyerLib.shared().appInviteOneLinkID = "<ONE_LINK_ID>"
```
- `AppsFlyerLib.shared().appsFlyerDevKey` could be received in AppsFlyer dashboard. If you don't have one, see instructions [here](https://support.appsflyer.com/hc/en-us/articles/207377436-Adding-an-app-to-AppsFlyer).
- `AppsFlyerLib.shared().appleAppID` is an identifier of you app in AppStore.
- `AppsFlyerLib.shared().appInviteOneLinkID` is OneLink ID for your app. If you dont have one, please read [here](https://support.appsflyer.com/hc/en-us/articles/208874366-OneLink-links-and-experiences#create-a-onelink-link).
More details could be found. [here](https://dev.appsflyer.com/hc/docs/integrate-ios-sdk).

### Sending events
- `StartTrial` - this event should be sent as soon as deepLink was received. This will be called automatically if you will use Tracky.swift.
- `Purchase` - this event should be sent to track purchase. In Tracky.swift there is a cnvenient `trackPurchase(currency:value:)` method to call this.
Check Tracky.swift to learn more about events. 
