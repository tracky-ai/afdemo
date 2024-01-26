//
//  Tracky.swift
//  AFDemo
//

import Foundation
import UIKit
import AppsFlyerLib // SPM: https://github.com/AppsFlyerSDK/AppsFlyerFramework

class AppsFlyerWorker: NSObject, AppsFlyerLibDelegate, DeepLinkDelegate {
    let appsFlyerDevKey: String
    let appleAppID: String
    init(
        appsFlyerDevKey: String,
        appleAppID: String
    ) {
        self.appsFlyerDevKey = appsFlyerDevKey
        self.appleAppID = appleAppID
    }

    var log: ((String) -> Void)? = nil
    var deepLinkHandler: ((String) -> Void)? = nil
    
    func start(
        log: ((String) -> Void)?,
        deepLinkHandler: ((String) -> Void)?
    ) {
        self.log = log
        self.deepLinkHandler = deepLinkHandler
        
        AppsFlyerLib.shared().appsFlyerDevKey = self.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = self.appleAppID
        
//        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)

        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().deepLinkDelegate = self

        #if DEBUG
        AppsFlyerLib.shared().isDebug = true
        #endif

        NotificationCenter.default.addObserver(
            self,
            selector: NSSelectorFromString("sendLaunch"),
            name: UIApplication.didFinishLaunchingNotification,
            object: nil
        )
    }
    
    @objc func sendLaunch() {
        //  your logic to retrieve CUID
        var customUserId = UserDefaults.standard.string(forKey: "customUserId")
        if customUserId == nil {
            customUserId = UUID().uuidString
        }
        
        if
            let customUserId = customUserId,
            customUserId != ""
        {
            // Set CUID in AppsFlyer SDK for this session
            AppsFlyerLib.shared().customerUserID = customUserId
        }

        log?("Start AppsFlyerLib")
        AppsFlyerLib.shared().start()
    }
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        if 
            let jsonData = try? JSONSerialization.data(withJSONObject: conversionInfo, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8)
        {
            self.log?("onConversionDataSuccess: \(jsonString)")
        } else {
            self.log?("onConversionDataSuccess: invalid data")
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        self.log?("onConversionDataFail: \(error)")
    }

    func didResolveDeepLink(_ result: DeepLinkResult) {
        self.log?("didResolveDeepLink. result.deepLink?.clickHTTPReferrer = \(result.deepLink?.clickHTTPReferrer ?? "<nil>")")
        
        switch result.status {
        case .notFound:
            self.log?("[AFSDK] Deep link not found")
            return
        case .failure:
            self.log?("[AFSDK] Error \(result.error!)")
            return
        case .found:
            self.log?("[AFSDK] Deep link found")
        }
        
        guard let deepLinkObj:DeepLink = result.deepLink else {
            self.log?("[AFSDK] Could not extract deep link object")
            return
        }
        
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub2") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub2"] as! String
            self.log?("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
        } else {
            self.log?("[AFSDK] Could not extract referrerId")
        }
        
        let deepLinkStr: String = deepLinkObj.toString()
        self.log?("[AFSDK] DeepLink data is: \(deepLinkStr)")
            
        if( deepLinkObj.isDeferred == true) {
            self.log?("[AFSDK] This is a deferred deep link")
        }
        else {
            self.log?("[AFSDK] This is a direct deep link")
        }
        
        //If deep_link_value doesn't exist
        if
            let deepLinkValue = deepLinkObj.deeplinkValue,
            deepLinkValue != ""
        {
            self.deepLinkHandler?(deepLinkValue)
        }
    }
}

class Tracky {
    let appsFlyerWorker: AppsFlyerWorker
    init(
        appsFlyerDevKey: String,
        appleAppID: String
    ) {
        appsFlyerWorker = AppsFlyerWorker(appsFlyerDevKey: appsFlyerDevKey, appleAppID: appleAppID)
    }
    
    var log: ((String) -> Void)? = nil
    var deepLinkValue: String? {
        get { return UserDefaults.standard.value(forKey: "deepLinkValue") as? String }
        set { UserDefaults.standard.setValue(newValue, forKey: "deepLinkValue") }
    }
    
    func start(log: ((String) -> Void)?) {
        self.log = log
        self.appsFlyerWorker.start(log: log) { deepLinkValue in
            self.log?("Tracky: deep link value = \(deepLinkValue)")
            self.trackInstall()
            self.deepLinkValue = deepLinkValue
        }
    }
    
    var task: URLSessionDataTask? = nil
    
    func trackEvent(deepLinkValue: String, eventName: String, params: [String: String] = [:]) {
        let websiteId = "6b3b5545-beac-4abe-afd6-e111a75ded0b"
        var urlString = "https://tracky-ai-backend.onrender.com/v1/websites/\(websiteId)/track/events/application?deep_link_value=\(deepLinkValue)&event_name=\(eventName)"
        for (key, value) in params {
            urlString.append("&\(key)=\(value)")
        }
        
        guard let url = URL(string: urlString) else {
            self.log?("Invalid URL string")
            return
        }

        self.log?("Call event: \(urlString)")

        task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.log?("Event response:\n\(String(data: data, encoding: .utf8)!)")
            }
        }
        task?.resume()

    }
    
    func trackInstall() {
        if let deepLinkValue = self.deepLinkValue {
            self.trackEvent(deepLinkValue: deepLinkValue, eventName: "StartTrial")
        }
    }

    func trackPurchase(currency: String, value: String) {
        if let deepLinkValue = self.deepLinkValue {
            self.trackEvent(deepLinkValue: deepLinkValue, eventName: "Purchase", params: [
                "currency": currency,
                "value": value
            ])
        }
    }
    
    func trackAddToCart() {
        if let deepLinkValue = self.deepLinkValue {
            self.trackEvent(deepLinkValue: deepLinkValue, eventName: "AddToCart")
        }
    }

    func trackFinalEvent() {
        if let deepLinkValue = self.deepLinkValue {
            self.trackEvent(deepLinkValue: deepLinkValue, eventName: "FinalEvent")
        }
    }
}
