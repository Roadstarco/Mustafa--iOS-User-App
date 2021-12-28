//
//  WelcomeViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 11/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class WelcomeViewController: BaseViewController {

    
    override func setupUI() {
//        if let token = AccessToken.current,
//                !token.isExpired {
//            let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
//            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
//                        }
        if UserDefaults.standard.bool(forKey: "alreadyLoggedIn") == true {
            let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
            
            
        }
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    
    
    @IBAction func onClickSignIn(_ sender: Any) {
        let signInVC = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.SignInViewController) as! SigninViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @IBAction func onCLickSignUp(_ sender: Any) {
        let signUpVc = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.SignUpViewController) as! SignUpViewController
        self.navigationController?.pushViewController(signUpVc, animated: true)
    }
}
