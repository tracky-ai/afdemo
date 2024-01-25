//
//  AppDelegate.swift
//  AFDemo
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var viewController: ViewController?
    let tracky = Tracky(
        appsFlyerDevKey: "<YOUR_DEV_KEY>",
        appleAppID: "<APPLE_APP_ID"
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.viewController = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateInitialViewController() as? ViewController
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        tracky.start { message in
            #if DEBUG
            self.viewController?.addLine(message)
            #endif
        }
        self.viewController?.purchaseHandler = { [weak self] in
            self?.tracky.trackPurchase(
                currency: "USD",
                value: "9,99"
            )
        }
        self.viewController?.addToCartHandler = {  [weak self] in
            self?.tracky.trackAddToCart()
        }
        self.viewController?.finalEventHandler = { [weak self] in
            self?.tracky.trackFinalEvent()
        }
        
        // Override point for customization after application launch.
        return true
    }

}

