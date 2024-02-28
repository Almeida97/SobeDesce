//
//  customButtonExtension.swift
//  SobeDesce
//
//  Created by User on 30/01/2024.
//

import Foundation
import UIKit

extension UIButton {
    
    func myDefaultStyle() {
        
    }
    
    func borderAnimation(show: Bool) {
        let border = CALayer()
        border.name = "border"
        border.frame = CGRect(x: 0, y: self.frame.size.height - 5, width:  10, height: self.frame.size.height)
        border.borderWidth = 5
        border.borderColor = UIColor.white.cgColor
        if show {
            let positionAnimation = CABasicAnimation(keyPath: "bounds.size.width")
            positionAnimation.fromValue =  0
            positionAnimation.toValue =   self.frame.size.width
            positionAnimation.duration = 0.5
            // MARK: Add Animation to Layer
            border.add(positionAnimation, forKey: "bounds.size.width")
            self.layer.addSublayer(border)
            border.frame.size.width = self.frame.size.width
            self.layer.masksToBounds = true
        }else{
            self.layer.sublayers?.forEach({ (layer) in
                if layer.name == "border" {
                    layer.removeFromSuperlayer()
                    }
            })
        }
    }
}
