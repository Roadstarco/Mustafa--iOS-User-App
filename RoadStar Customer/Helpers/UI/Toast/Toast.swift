//
//  Toast.swift
//  OnSalon
//
//  Created by Faizan Ali on 13/05/2020.
//  Copyright © 2020 com.OnSalon.Technology. All rights reserved.
//

import UIKit

public class Toast: UIView
{
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    
    public static func showError(error: LocalizedError, showButton: Bool = false){
        let message = [error.errorDescription,
            error.failureReason,
            error.recoverySuggestion
            ].compactMap { $0 }
            .joined(separator: "\n\n")
        
        showError(message: message, showButton: showButton)
    }
    
    public static func showError(message: String, showButton: Bool = false){
        Run.onMain
            {
            let toast : Toast = UIView.fromNib(from: Bundle(for: Toast.self))
            toast.setupUI(message: message, isError: true, showButton: showButton)
            UIApplication.shared.keyWindow?.addSubview(toast)
        }
       
    }
    
    public static func show(message: String, showButton: Bool = false){
        Run.onMain {
            let toast : Toast = UIView.fromNib(from: Bundle(for: Toast.self))
            toast.setupUI(message: message, showButton: showButton)
            UIApplication.shared.keyWindow?.addSubview(toast)
        }
        
    }
    
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        hide()
    }
    
    private func setupUI(message: String, isError: Bool = false,  showButton: Bool = false) {
        
        btnClose.isHidden = !showButton
       
        
        if(isError){
            viewMessage.backgroundColor = UIColor.red
            lblMessage.textColor = UIColor.white
        }
        
        lblMessage.text = message
        self.frame = (UIApplication.shared.keyWindow?.bounds)!
        
        self.frame.origin.y = -92 // below screen
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin.y = 0
            
        }) { (completed) in
            if(!showButton){
                self.perform(#selector(self.hide), with: nil, afterDelay: 3.0)
            }
        }
        
    }
    
    @IBAction func swippedUp(_ sender: Any) {
        hide()
    }
   
    
    @objc func hide()
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin.y = -92
            
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}
