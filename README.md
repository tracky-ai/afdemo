# Tracky - iOS Integration Guide

## Integrating Tracky into Your iOS Application

### Step 1: Adding the AppsFlyer SDK
To incorporate the AppsFlyer SDK into your iOS app, you can add it as an SPM (Swift Package Manager) package dependency. Navigate to your project settings, access the 'Package Dependencies' tab, and add the AppsFlyer package to your target under `Package Dependencies`. For alternatives to SPM or for additional details, refer to the AppsFlyer [Install SDK guide](https://dev.appsflyer.com/hc/docs/install-ios-sdk).

### Step 2: Incorporating Tracky Code
Firstly, add the `Tracky.swift` file to your project, which is available in this example project.

For those utilizing the appDelegate, integrate the `start` method of the `Tracky` class instance within the `application:didFinishLaunchingWithOptions:` method as follows:
```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Existing AppDelegate variables
    
    let tracky = Tracky(
        appsFlyerDevKey: "<YOUR_DEV_KEY>",
        appleAppID: "<APPLE_APP_ID>",
        websiteID: "<TRACKY_WEBSITE_ID>"
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Existing app initialization code
        
        tracky.start { message in
            #if DEBUG
            print(message)
            #endif
        }
    }    
}
```

Feel free to modify `Tracky.swift` code to suit your project's needs.

### Step 3: Updating AppsFlyer SDK Configuration 
Before usage, update the `<YOUR_DEV_KEY>`, `<APPLE_APP_ID>` and `<TRACKY_WEBSITE_ID>` parameters of the `Tracky` initializer:
```swift
    let tracky = Tracky(
        appsFlyerDevKey: "<YOUR_DEV_KEY>",
        appleAppID: "<APPLE_APP_ID>",
        websiteID: "<TRACKY_WEBSITE_ID>"
    )
```
- Acquire `<YOUR_DEV_KEY>` from the AppsFlyer dashboard. Refer to [Adding an app to AppsFlyer](https://support.appsflyer.com/hc/en-us/articles/207377436-Adding-an-app-to-AppsFlyer) if needed.
- `<APPLE_APP_ID>` is your app's identifier in the AppStore.
- `<TRACKY_WEBSITE_ID>` is your Account ID which will be provided by the Tracky team during technical integration.


Find more details in the [iOS SDK Integration guide](https://dev.appsflyer.com/hc/docs/integrate-ios-sdk).

### Step 4: Event Handling
- Refer to `Tracky.swift` for event sending examples.
- `StartTrial`: Trigger this event when a deepLink is received. `Tracky.swift` handles this automatically. Refer to `Tracky.swift` for additional event details. Example: `trackStartTrial()`
- `Purchase`: To track purchases, use the `trackPurchase(currency:value:)` method in `Tracky.swift`. Currency and value parameters are mandatory. Refer to `Tracky.swift` for additional event details. Example: `trackPurchase(currency: "USD",value: "9,99")`

## Testing Your Integration

### 1. Facebook Configuration
Please, check our guide on how to create a test link in [this document](https://github.com/tracky-ai/tracky-demo-iOS/blob/main/Doc/Tracky.AI%20-%20Creating%20a%20test%20Facebook%20Ads%20link.pdf).
- Your App's landing page will be located at `https://tracky.ai/lp/<YOUR_APP>`.
- `<YOUR_APP>` url will be provided by the Tracky team during technical integration.

### 2. Preparing Your Device
Follow the comprehensive guide on [Registering test devices](https://support.appsflyer.com/hc/en-us/articles/207031996) for device preparation.

We tested the AppsFlyer integration using the IDFV (Identifier for Vendor) method:
1. [Install the IDFV test tool app](https://dev.appsflyer.com/hc/docs/install-the-idfv-test-tool-app#how-to-install-the-idfv-testing-tool-app).
2. [Register your test device](https://support.appsflyer.com/hc/en-us/articles/207031996#add-a-device-manually-via-the-user-interface).

Keep the IDFV test tool app installed until all testing is complete. Note that Apple assigns a unique IDFV upon the installation of the first app from a vendor and removes it when the last app from that vendor is uninstalled. If you uninstall the test tool app, you might have to re-register your test device.

### 3. Running Local Tests on Your Device
1. Uninstall your app from the device.
2. Use the test link generated in Step 1 to navigate to `https://tracky.ai/lp/<YOUR_APP>?fbclid=...` in a browser.
3. On the landing page, click the "Download on the AppStore" button to be redirected to the AppStore. If your app isn't available on the AppStore yet, a message stating "The app you are looking for is unavailable" will appear. This is expected.
4. Compile and launch the app on your device using Xcode.
5. Integration is successful if you receive deepLink data, including a `deepLinkValue` parameter. If you use `Tracky.swift`, this value is handled automatically and can be accessed via the `Tracky.deepLinkValue` property.

### 4. Running Production Test via App Store.
1. Uninstall your app from the device.
2. Use the test link generated in Step 1 to navigate to the landing page `https://tracky.ai/lp/<YOUR_APP>?fbclid=...` in a browser.
3. On the landing page, click the "Download on the AppStore" button to be redirected to the AppStore.
4. Install and open the App from the App Store.
5. Trigger conversion events that you have set up in Step 4 while using the app (install, sign up, start trial, purchase, etc).
6. Integration is successful if you receive the conversion events in your Tracky Dashboard. Events should be received in real-time.

### 5. Verify Events Reception in Facebook Events Manager
1. Send test `StartTrial` or `Purchase` events from your iOS App.
2. You can verify that the test events are being received correctly in your [Facebook Events Manger](https://business.facebook.com/events_manager2/). Test events typically appear in Events Manager within 30 minutes.
