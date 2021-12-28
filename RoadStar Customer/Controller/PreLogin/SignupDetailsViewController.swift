
import UIKit
import SkyFloatingLabelTextField
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class SignupDetailsViewController: BaseViewController {
    
    

    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var orView: UIView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var gmailLogin: UIImageView!
    @IBOutlet weak var fbloginButton: UIImageView!
    
    var socialID: String = ""
    var firstName: String = ""
    var secondName: String = ""
    var email: String = ""
    var fbCountry: String = ""
    var fromFB = false
    var fromGoogle = false
    var gmail: String = ""
    var passForGmailLogin : String = ""
    var phoneNumber: String!
    var countryname: String = ""
//    48653661783-cvnnnb8bodbia29fh39seb960htt0g66.apps.googleusercontent.com
//
    let signInConfig = GIDConfiguration.init(clientID: "234677169665-a2qalvl55n94ianmjlo6k9o7ar69to3o.apps.googleusercontent.com")
    
    override func setupUI() {
        self.txtPassword.isSecureTextEntry = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
    
        
        gmailLogin.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(gmailLoginTapped))
        gmailLogin.addGestureRecognizer(gestureRecognizer)
        
        fbloginButton.isUserInteractionEnabled = true
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action:  #selector(fbLoginTapped))
        fbloginButton.addGestureRecognizer(gestureRecognizer1)
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }

@objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    //MARK: - Manual signup
    @IBAction func onCLickNextBtn(_ sender: Any) {
        
        if isValidData(){
            
            print(countryname.lowercased())
            let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
            let signUp = SignUp(login_by: "manual",
                        first_name:txtFirstName.text!,
                        last_name: txtLastName.text!,
                        mobile: phoneNumber,
                        social_unique_id: "",
                        email: txtEmail.text!,
                        grant_type: "password",
                        client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                        client_id: "2",
                        password: txtPassword.text!,
                        device_type: "ios",
                        device_id: deviceid ,
                        device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "" ,
                        country_name: countryname.lowercased(),
                        address: txtAddress.text!)
            
            NetworkRepository.shared.signUpRepository.signUp(with: signUp) { (signUpResponse, error) in
                
                if let error = error{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                    
                } else if signUpResponse != nil{
                    print(signUpResponse as Any)
                    if  signUpResponse?.email?.isEmpty == false{
                    let user: UserProfile = UserProfile.fromSignUp(response: signUpResponse!)
                  
                    user.isLoggedIn = true
                    user.save()
                    App.shared.updateUser()
                    self.loginApi()
                    }else{
                        Toast.show(message: "User already created with this account, Continue from login Screen ")
                    
                    }
                    
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER.")
                }
            }
        }
    }
    //MARK: - signup from facebook
    @objc func fbLoginTapped() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email, .userLocation ], viewController: self) { (result) in
                switch result{
                case .cancelled:
                    print("Cancel button click")
                    Toast.showError(message: "Please login to facebook to complete the process")
                    self.fromFB = false
                case .success:
                    let params = ["fields":"email, name, first_name, last_name, location"]
                    let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                    let Connection = GraphRequestConnection()
                    Connection.add(graphRequest) { (Connection, result, error) in
                        let result = result as! [String : AnyObject]
                        print(result)
                        self.firstName = result["first_name"] as! String
                        self.secondName = result["last_name"] as! String
                        self.email = result["email"] as! String
                        self.socialID = result["id"] as! String
                        let location = result["location"] as! [String:Any]
                        self.fbCountry = location["name"] as! String
                        self.fromFB = true
                        print(self.firstName)
                        print(self.secondName)
                        print(self.email)
                        print(self.socialID)
                        print(location)
                        print(self.fbCountry)
                        let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
                        let signUp = SignUp(login_by: "facebook",
                                    first_name: self.firstName,
                                    last_name: self.secondName,
                                    mobile: self.phoneNumber,
                                    social_unique_id: self.socialID,
                                    email: self.email,
                                    grant_type: "password",
                                    client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                                    client_id: "2",
                                    password: self.socialID,
                                    device_type: "ios",
                                    device_id: deviceid,
                                    device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "",
                                    country_name: self.countryname.lowercased(),
                                    address: "Lahore, Pakistan" /*self.fbCountry*/)
                        
                        NetworkRepository.shared.signUpRepository.signUp(with: signUp) { (signUpResponse, error) in
                            
                            if let error = error{
                                Toast.show(message: "Something went wrong!")
                                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                                
                            } else if signUpResponse != nil{
                                print(signUpResponse as Any)
                                if  signUpResponse?.email?.isEmpty == false{
                                let user: UserProfile = UserProfile.fromSignUp(response: signUpResponse!)
                              
                                user.isLoggedIn = true
                                user.save()
                                App.shared.updateUser()
                                self.loginApi()
                                }else{
                                    Toast.show(message: "User already created with this account, Continue from login Screen ")
                                
                                }
                                
                            } else{
                                Toast.show(message: "Something went wrong!")
                                print("Something went wrong in SIGNUP THE USER.")
                            }
                        }
                    }
                    
                    
                    Connection.start()
                default:
                    break
                }
            }
        }
        
    //MARK: - signup from google
    @objc func gmailLoginTapped() {
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error != nil else { return }
            Toast.showError(message: "Please login to google to complete the process")
            self.fromGoogle = false
            guard error == nil else { return }
            guard let user = user else { return }
            
                let emailAddress = user.profile?.email
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                let socialID = user.userID
                self.gmail = emailAddress ?? ""
                self.passForGmailLogin = socialID ?? ""
                self.fromGoogle = true
            let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
            let signUp = SignUp(login_by: "google",
                        first_name: givenName!,
                        last_name: familyName!,
                        mobile: self.phoneNumber,
                        social_unique_id: socialID!,
                        email: emailAddress!,
                        grant_type: "password",
                        client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                        client_id: "2",
                        password: socialID!,
                        device_type: "ios",
                        device_id: deviceid ,
                        device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "" ,
                        country_name: self.countryname.lowercased(),
                        address: "Lahore, Pakistan")

            NetworkRepository.shared.signUpRepository.signUp(with: signUp) { (signUpResponse, error) in
                
                if let error = error{
                    print(error)
                    
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                    
                } else if signUpResponse != nil{
                    print(signUpResponse as Any)
                    if  signUpResponse?.email?.isEmpty == false{
                    let user: UserProfile = UserProfile.fromSignUp(response: signUpResponse!)
                  
                    user.isLoggedIn = true
                    user.save()
                    App.shared.updateUser()
                    self.loginApi()
                        
                    }else{
                        Toast.show(message: "User already created with this account, Continue from login Screen ")
                    }
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER.")
                }
            }
          }
    }
    
    func loginApi(){
        let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
        var logIn: LogIn?
        if fromGoogle == true{
            logIn = LogIn(grant_type: "password",
                             client_id: 2,
                             client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                             username: self.gmail,
                             password: self.passForGmailLogin,
                             scope: "",
                             device_type: "ios",
                             device_id: deviceid ,
                             device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "")
            
        }
        else if self.fromFB == true{
            logIn = LogIn(grant_type: "password",
                             client_id: 2,
                             client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                             username: self.email,
                             password: self.socialID,
                             scope: "",
                             device_type: "ios",
                             device_id: deviceid ,
                             device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "")
            
        }else{
         logIn = LogIn(grant_type: "password",
                          client_id: 2,
                          client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                          username: txtEmail.text!,
                          password: txtPassword.text!,
                          scope: "",
                          device_type: "ios",
                          device_id: deviceid ,
                          device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "")
        }
        NetworkRepository.shared.logInRepository.logIn(with: logIn!) { (logInResponse, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                
            } else if let loginRes = logInResponse{
                
                print(loginRes.access_token ?? "no token")
                
                UserDefaults.standard.setValue(loginRes.access_token, forKey: "loginToken")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(true, forKey: "alreadyLoggedIn")
                let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
                
                
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
        
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func signUp() {
        
        
    }
    
    func isValidData() -> Bool {
        
        if txtEmail.text == nil || txtEmail.text == ""{
            Toast.show(message: "Email required!")
            return false
        } else if txtFirstName.text == nil || txtFirstName.text == ""{
            Toast.show(message: "First Name required!")
            return false
        } else if txtLastName.text == nil || txtLastName.text == ""{
            Toast.show(message: "Last Name required!")
            return false
        } else if txtAddress.text == nil || txtAddress.text == ""{
            Toast.show(message: "Address required!")
            return false
        } else if txtPassword.text == nil || txtPassword.text == ""{
            Toast.show(message: "Password required!")
            return false
        } else if txtPassword.text!.count < 6{
            Toast.show(message: "Password should be at least 6 digits!")
            return false
        }
        
        return true
    }
    
}
    //        let loginButton = FBLoginButton()
    //        loginButton.translatesAutoresizingMaskIntoConstraints = false
    //        loginButton.delegate = self
    //        loginButton.permissions = ["public_profile", "email", "user_location"]
    //
    //        loginView.addSubview(loginButton)
    //
    //        NSLayoutConstraint.activate([
    //            loginButton.topAnchor.constraint(equalTo:  loginView.topAnchor),
    //            loginButton.centerXAnchor.constraint(equalTo:  loginView.centerXAnchor),
    //            ])

    
    //    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    //       let token = result?.token?.tokenString
    //
    //
    //
    //        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
    //                                                 parameters: ["fields":"email, name, first_name, last_name, location"],
    //                                                 tokenString: token,
    //                                                 version: nil,
    //                                                 httpMethod: .get)
    //        request.start(completion: { connection, result, error in
    //
    //            if let result = result {
    //                print(result)
    //                let result = result as! [String:Any]
    //                self.firstName = result["first_name"] as! String
    //                self.secondName = result["last_name"] as! String
    //                self.email = result["email"] as! String
    //                self.socialID = result["id"] as! String
    //                let location = result["location"] as! [String:Any]
    //                self.fbCountry = location["name"] as! String
    //                self.fromFB = true
    //                let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
    //                let signUp = SignUp(login_by: "facebook",
    //                            first_name: self.firstName,
    //                            last_name: self.secondName,
    //                            mobile: self.phoneNumber,
    //                            social_unique_id: self.socialID,
    //                            email: self.email,
    //                            grant_type: "password",
    //                            client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
    //                            client_id: "2",
    //                            password: self.socialID,
    //                            device_type: "ios",
    //                            device_id: deviceid,
    //                            device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "",
    //                            country_name: self.countryname.lowercased(),
    //                            address: self.fbCountry)
    //
    //                NetworkRepository.shared.signUpRepository.signUp(with: signUp) { (signUpResponse, error) in
    //
    //                    if let error = error{
    //                        Toast.show(message: "Something went wrong!")
    //                        print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
    //
    //                    } else if signUpResponse != nil{
    //                        print(signUpResponse as Any)
    //                        if  signUpResponse?.email?.isEmpty == false{
    //                        let user: UserProfile = UserProfile.fromSignUp(response: signUpResponse!)
    //
    //                        user.isLoggedIn = true
    //                        user.save()
    //                        App.shared.updateUser()
    //                        self.loginApi()
    //                        }else{
    //                            Toast.show(message: "User already created with this account, Continue from login Screen ")
    //
    //                        }
    //
    //                    } else{
    //                        Toast.show(message: "Something went wrong!")
    //                        print("Something went wrong in SIGNUP THE USER.")
    //                    }
    //                }
    //            }
    //
    //            if let error = error {
    //                Toast.showError(message: "Please login to facebook to complete the process")
    //                self.fromFB = false
    //                print(error)
    //            }
    //
    //        })
    //    }
    //
    //    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    //
    //    }
