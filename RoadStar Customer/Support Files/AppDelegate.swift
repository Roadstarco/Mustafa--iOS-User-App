//
//  AppDelegate.swift
//  RoadStar Customer
//
//  Created by Roamer on 04/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import SideMenu
import GoogleMaps
import Firebase
import Stripe
import UserNotifications
import SwiftyJSON
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        48653661783-cvnnnb8bodbia29fh39seb960htt0g66.apps.googleusercontent.com
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            UserDefaults.standard.set(token, forKey: "fcmtoken")
              print(UserDefaults.standard.string(forKey: "fcmtoken") as Any)
            let test = UserDefaults.standard.string(forKey: "fcmtoken")!
            print("FCM registration token2: \(test)")
              if UserDefaults.standard.string(forKey: "token") != nil {
              }
            
          }
        }
        
        App.shared.initialize(application)
        STPAPIClient.shared.publishableKey = "pk_test_51HeDaeHV7Xodq4BS6RlcHrqGwXVVQZNgTcZPUn3T3lQdxr7jbGFQ72lx8ZcpAhiLZCmnghkuTTrI9u0dLdhnPgo600rrYtZzSS"
        
//        GMSServices.provideAPIKey("AIzaSyA5l_TkMB4GUvCJx_lNcgz23CjFjdYwmc8")//Old one
        GMSServices.provideAPIKey("AIzaSyCO--TQ_iF9WC2_Gv7KgjasEmnEoxwbF-E")//New one

        //AIzaSyCO--TQ_iF9WC2_Gv7KgjasEmnEoxwbF-E
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }
        return true
    }
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
            var handled: Bool
            handled = GIDSignIn.sharedInstance.handle(url)
                  if handled {
                    return true
                  }
            return false
        }
    
    func setRootController(controller: UIViewController){
        window = window ?? UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = controller
        window!.makeKeyAndVisible()
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

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey: "fcmtoken")
      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
        
  
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X.2hhx", $1)})
       
        
        UserDefaults.standard.set(deviceTokenString, forKey: "token")
         
         // Print it to console
         print("APNs device token: \(deviceTokenString)")
         
         // Persist it in your backend in case it's new
         
         let tokenParts = deviceToken.map { data -> String in
             print("Moeezzzz")
             return String(format: "%02.2hhx", data)
         }
         let tokenk = tokenParts.joined()
         
         print("deviceToken: \(tokenk)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      // With swizzling disabled you must let Messaging know about the message, for Analytics
       Messaging.messaging().appDidReceiveMessage(userInfo)

      // ...

      // Print full message.
      print(userInfo)

      // Change this to your preferred presentation option
        if #available(iOS 14.0, *) {
            completionHandler([[.banner,.list, .sound]])
        } else {
            // Fallback on earlier versions
        }
    }
    
}

