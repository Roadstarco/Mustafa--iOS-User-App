

import UIKit

/// A protocol that lets us instantiate view controllers from Main storyboard.
protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    // Creates a view controller from our storyboard. This relies on view controllers having the same storyboard identifier as their class name. This method shouldn't be overridden in conforming types.
    static func instantiateMain() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // swiftlint:disable:next force_cast
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No storyboard with this identifier ")
        }
        return vc
    }
    
    static func instantiatePreLogin() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "PreLogIn", bundle: Bundle.main)
        
        // swiftlint:disable:next force_cast
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No storyboard with this identifier ")
        }
        return vc
    }
    
    static func instantiateBooking() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Booking", bundle: Bundle.main)
        
        // swiftlint:disable:next force_cast
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No storyboard with this identifier ")
        }
        return vc
    }
    
    static func instantiateMenu() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
        
        // swiftlint:disable:next force_cast
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No storyboard with this identifier ")
        }
        return vc
    }
    
    
    
}

