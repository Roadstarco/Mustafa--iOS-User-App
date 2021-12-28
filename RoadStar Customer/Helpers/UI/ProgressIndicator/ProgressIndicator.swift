//
//  ProgressIndicator.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/8/29.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

public class ProgressIndicator: UIView {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mainView: UIView!
   //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var lblMessage: UILabel!
   
    var stoped = false
   public class func show(message: String) -> ProgressIndicator{
       
       let vw : ProgressIndicator = UIView.fromNib(from: Bundle(for: ProgressIndicator.self))
          
    vw.backgroundColor = Theme.overlayBackgroundColor
    vw.lblMessage.textColor = Theme.backgroundColor.withAlphaComponent(0.70)
    //vw.activityIndicator.tintColor = Theme.primaryFontColor
    vw.mainView.backgroundColor = Theme.brandColor
       
       
       vw.lblMessage.text = message
       //vw.activityIndicator.startAnimating()
    //vw.imgView.backgroundColor = Theme.brandColor
       vw.rotateView(targetView: vw.imgView)
    
       vw.frame = CGRect.init(x: 0, y: 0, width:  UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
       UIApplication.shared.keyWindow?.addSubview(vw)
       
       
       vw.alpha = 0
       
       UIView.animate(withDuration: 0.3, animations: {
           vw.alpha = 1
        }) { (completion) in
       }
       
       return vw
   }
   
   public func close(){
       Run.onMain {
        self.stoped = true
           UIView.animate(withDuration: 0.3, animations: {
               self.alpha = 0
               self.removeFromSuperview()
            }) { (completion) in
           }
       }
   }
    
    // Rotate <targetView> indefinitely
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            if !self.stoped{
                self.rotateView(targetView: targetView, duration: duration)
            }
        }
    }

}
