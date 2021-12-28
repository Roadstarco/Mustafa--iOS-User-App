//
//  LaunchScreenViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 04/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class LaunchScreenViewController: BaseViewController {

    override func setupUI() {
        self.checkLogin()
        self.loginUser()
    }
    

}

extension LaunchScreenViewController {
    
    

    
    func checkLogin() {
        
//        self.user = self.user.getCachedUser()
//        if user.isLoggedIn() {
//            loginUser()
//        }
//        else {
//            continueToMain()
//        }
    }
    
//    func refreshToken() {
//        SVProgressHUD.show()
//        NetworkManager.sharedInstance.getRefreshToken(self.user) { (apiResponse, token, user, spot)  in
//            SVProgressHUD.dismiss()
//            if apiResponse.status == Strings.StatusCodes.success {
//                print("****************************************")
//                print("Successfully Signed In!")
//                print(apiResponse.message)
//
//                if let fcm_token = UserDefaults.standard.string(forKey: UserDefaults.Keys.fcmToken) {
//                    self.user.fcm_token = fcm_token
//                }
//                else {
//                    self.user.fcm_token = "null"
//                }
//
//                self.user.token = token
//                if let userLocal = user {
//                   self.user.wallet = userLocal.wallet
//                }
//                self.user.cacheUser()
//
//                if let spot = spot {
//                    if spot.spot_id != "" {
//                        self.user = self.user.getCachedUser()
//                        let savedSpot = SavedSpot(spotId: spot.spot_id)
//                        let userDefaults = UserDefaults.standard
//                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedSpot)
//
//                        //check if the spot is created by the user himself
//                        if self.user.id == Int(spot.user_id) && spot.status == Strings.ParkingStatus.free {
//                            userDefaults.set(encodedData, forKey: UserDefaults.Keys.currentFreeSpot)
//                            userDefaults.synchronize()
//                        }
//                        else if self.user.id == Int(spot.user_id) && spot.status == Strings.ParkingStatus.booked && spot.created_by_user.id == self.user.id {
//                            userDefaults.set(encodedData, forKey: UserDefaults.Keys.currentIncomingSpot)
//                            userDefaults.synchronize()
//                        }
//                        else if self.user.id == Int(spot.booked_by) && spot.status == Strings.ParkingStatus.parked{
//                            userDefaults.set(encodedData, forKey: UserDefaults.Keys.currentParkedSpot)
//                            userDefaults.synchronize()
//                        }
//                        else if self.user.id == Int(spot.booked_by) {
//                            userDefaults.set(encodedData, forKey: UserDefaults.Keys.currentEnrouteSpot)
//                            userDefaults.synchronize()
//                        }
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    self.finishSignIn()
//                }
//            }
//            else {
//                print(apiResponse.message)
//                DispatchQueue.main.async {
//                    self.signOut()
//                }
//            }
//        }
//    }
    
    
    // MARK: App Flow Functions
    
    func loginUser() {
//        if App.shared.user.isLoggedIn{
//            continueToMain()
//            return
//        }
        continueToWelcome()
    }
    
 
    func continueToWelcome() {
         let welcomNav = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.WelcomNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(welcomNav, animated: true, completion: nil)
     }
    
    func continueToMain() {
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
}
