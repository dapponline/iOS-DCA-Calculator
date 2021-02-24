//
//  UIAnimatable.swift
//  iOS-DCA-Calculator
//
//  Created by Leon Smith on 24/02/2021.
//

import Foundation
import MBProgressHUD

protocol UIAnimatable where Self: UIViewController  {
    func showLoadingAnimation()
    func showHidingAnimation()
}

extension UIAnimatable {
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func showHidingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
