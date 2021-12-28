//
//  UIView+Ext.swift
//  RoadStar Customer
//
//  Created by Roamer on 12/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds         = false
        layer.shadowColor           = UIColor.black.cgColor
        layer.shadowOpacity         = 0.5
        layer.shadowOffset          = .zero
        layer.shadowRadius          = 5
        layer.shouldRasterize       = true
        layer.rasterizationScale    = scale ? UIScreen.main.scale : 1
    }
    
    public class func fromNib<T: UIView>(from bundle: Bundle = Bundle.main) -> T {
        return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    public func takeScreenshot() -> UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
            return image
    }

}


extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}


extension UIApplication{
    static func AppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
}


//@IBDesignable extension UIView {
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            guard let cgColor = layer.borderColor else {
//                return nil
//            }
//            return UIColor(cgColor: cgColor)
//        }
//        set { layer.borderColor = newValue?.cgColor }
//    }
//
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//}
