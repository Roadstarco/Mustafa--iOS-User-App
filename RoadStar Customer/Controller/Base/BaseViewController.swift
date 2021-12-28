//
//  BaseViewController.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/8/29.
//  Copyright © 2020 Faizan.Technology All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController : UIViewController {
    
    public weak var parentVC: UIViewController? = nil
    public var onClose : (()->Void)? = nil
    
    public init(){
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    
    public init(parent: UIViewController?, block: (()->Void)? ){
        parentVC = parent
        onClose = block
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    /// This method is called only once at the initialization.
    /// Override it to setup initial state of your controller.
    open func initialize(){
       registerObservers()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTheme()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
    }

    
    /// This method is called when this view is entering in foreground
    /// For example: When a call comes and user respond to it and come back to the app
    @objc open func willEnterForeground(){}
    
    
    /// Use this method to setup initial state of the the view.
    /// It is automatically called at ViewDidLoad
    open func setupUI(){
        fatalError("Developer Error. Must override this function")
    }
    
    /// Use this method to setup initial state of the the view.
    /// It is automatically called at ViewDidLoad and ViewWillAppear events
    open func setupTheme(){
    }
    
    public func closeVC(animate: Bool){
        dismiss(animated: animate) { [unowned self] in
            self.onClose?()
        }
    }
    
   open func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func registerObservers(){
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    
    
    
}
