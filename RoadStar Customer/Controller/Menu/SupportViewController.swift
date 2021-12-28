//
//  SupportViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices
import UniformTypeIdentifiers
import SwiftyJSON
import FirebaseDatabase
import SDWebImage
class SupportViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, Storyboarded {
    
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var currentUserMessages: [String] = [String]()
    var otherUserMessages: [String] = [String]()
    
    var user_id = 0
    var first_name = ""
    var mess = [String:Any]()
    
    var currenttime = Int64(Date().timeIntervalSince1970 * 1000)
    var email = ""
    var picture = ""
    
    var fdate = Int64(Date().timeIntervalSince1970 * 1000)
    var ids = [String]()
    var messages: [String] = [String]()
    
    var indexes = [Int:String]()
    var counter = 0//group or single chat

    override func setupUI() {
        self.nameLabel.text = self.first_name
        if self.picture != ""{
            self.userImage.sd_setImage(with: URL(string: self.picture))
            self.userImage?.layer.cornerRadius = (self.userImage?.frame.size.width ?? 0.0) / 2
            self.userImage?.clipsToBounds = true
            self.userImage?.layer.borderWidth = 3.0
            self.userImage?.layer.borderColor = UIColor.white.cgColor
//        self.userImage.layer.borderWidth = 1.0
//        self.userImage.layer.masksToBounds = false
//        self.userImage.layer.borderColor = UIColor.white.cgColor
//            self.userImage.layer.cornerRadius = userImage.frame.size.width/1.5
//        self.userImage.clipsToBounds = true
        }else{
            
          self.userImage.image = UIImage(named: "manPHIcon")
            self.userImage?.layer.cornerRadius = (self.userImage?.frame.size.width ?? 0.0) / 2
            self.userImage?.clipsToBounds = true
            self.userImage?.layer.borderWidth = 3.0
            self.userImage?.layer.borderColor = UIColor.white.cgColor
        }
        self.getmessages()
        registerXib()
        messages = ["Hy", "Hello Sir How are you?"]
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.addDoneButtonOnKeyboard()
    }
    
    override func setupTheme() {
        super.setupTheme()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

        txtView.inputAccessoryView = doneToolbar
        }
    
    @objc func doneButtonAction(){
        txtView.resignFirstResponder()
        }
    
    func registerXib() {
        
        let nib = UINib.init(nibName: OtherUserMessageCell.nibName, bundle: nil)
        theTableView.register(nib, forCellReuseIdentifier: OtherUserMessageCell.nibName)
        
        let nib1 = UINib.init(nibName: CurrentUserMessageCell.nibName, bundle: nil)
        theTableView.register(nib1, forCellReuseIdentifier: CurrentUserMessageCell.nibName)
    }
    
    func handleSend(){
        let userIdString = String(user_id)
        let use = UserDefaults.standard.string(forKey: "uid")
        let currentChat = "\(use ?? "")_\(userIdString )"
        let currentChat1 = "\(userIdString )_\(use ?? "" )"
        print(currentChat)
        print(currentChat1)
        let message = txtView.text!
        let type = "text"
        let ref = FirebaseDatabase.Database.database().reference().child("Messages")
            .child(currentChat)
        let ref1 = FirebaseDatabase.Database.database().reference().child("Messages")
            .child(currentChat1)
        let friendmessage = FirebaseDatabase.Database.database().reference().child("Friends").child(use!).child(userIdString).child("message")
        let friendmessage1 = FirebaseDatabase.Database.database().reference().child("Friends").child(userIdString).child(use!).child("message")
        let childRef = ref.childByAutoId()
        let childRef1 = ref1.childByAutoId()
        let values = ["text": message, "idReceiver": userIdString , "idSender": use as Any, "isFuture": false, "status": "1", "timestamp": self.fdate , "type" : type ] as [String : Any]
        let lastmessage = ["text": message, "idReceiver": userIdString , "idSender": use as Any, "isFuture": false, "status": "1", "timestamp": self.fdate , "type" : type ] as [String : Any]
        friendmessage.updateChildValues(lastmessage)
        friendmessage1.updateChildValues(lastmessage)
        childRef.updateChildValues(values)
        childRef1.updateChildValues(values)
    }
    
    
    func getmessages(){
        let use = UserDefaults.standard.string(forKey: "uid") ?? ""
        let userIdString = String(user_id)
        var currentChat = ""
//        if(self.type == "0"){
//        currentChat = "\(self.receiver)"
//        }
//        else
//        {
            currentChat = "\(use)_\(userIdString)"
//        }
        
        print("CURRENT CHAT")
        print(currentChat)
        FirebaseDatabase.Database.database().reference().child("Messages").child(currentChat).observe(.childAdded) { (snapshot) in
            self.ids.append(snapshot.key)
            print(snapshot.key)
            print(snapshot.children)
            var dic = [String:Any]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                print("Snap is \(snap)")
                let key = snap.key
                print("Key is \(key)")
                let value = snap.value
                print("value is \(value ?? "")")
                dic[snap.key] = snap.value
                print("key = \(key)  value = \(value!)")
            }
            self.currenttime = Int64(Date().timeIntervalSince1970 * 1000)
            if(self.currenttime >= dic["timestamp"] as! Int64 ){
                self.mess[snapshot.key] = dic
                print("mess is \(self.mess[snapshot.key] ?? "")")
                self.indexes[self.counter] = snapshot.key
                self.counter = self.counter + 1
                print(self.mess)
                self.theTableView.reloadData()
                self.scrollToBottom()

            }
            
        }
        
        print("MESSSSSS")
        print(self.mess)
        
    }
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.indexes.count-1, section: 0)
            self.theTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = self.mess[indexes[indexPath.row] ?? ""] as! NSDictionary
        let message = dic["text"]
        let sender = dic["idSender"] as! String
        let use = UserDefaults.standard.string(forKey: "uid") ?? ""
        let currenttime = Int64(Date().timeIntervalSince1970 * 1000)
        
        
        if (use != sender){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: OtherUserMessageCell.nibName, for: indexPath) as! OtherUserMessageCell
        cell.setUI(text: message as! String)
            return cell
            
        }else{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentUserMessageCell.nibName, for: indexPath) as! CurrentUserMessageCell
        cell.setUI(text: message as! String)

        return cell
            
        }
    }

    @IBAction func btnBackTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    func continueToHome() {
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        self.handleSend()
//        messages.append(txtView.text)
//        theTableView.reloadData()
        txtView.text = nil
    }
}
extension UIImage {
    var circleMask: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: .init(origin: .init(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
//class RoundedImageView: UIImageView {
//
//    @override func layoutSubviews() {
//        super.layoutSubviews()
//        let radius = self.frame.width/2.0
//        layer.cornerRadius = radius
//        clipsToBounds = true // This could get called in the (requiered) initializer
//        // or, ofcourse, in the interface builder if you are working with storyboards
//    }
//
//}
