//
//  myColors.swift
//  SobeDesce
//
//  Created by User on 28/07/2023.
//

import Foundation
import UIKit

enum myColor: CaseIterable{
    case red
    case teal
    case blue
    case orange
    case green

    var associatedColor: UIColor {
        switch self {
        case .red: return UIColor(red: 239/255, green: 98/255, blue: 98/255, alpha: 1.0)
        case .teal: return UIColor(red: 70/255, green: 139/255, blue: 151/255, alpha: 1.0)
        case .blue: return UIColor(red: 29/255, green: 91/255, blue: 121/255, alpha: 1.0)
        case .orange: return UIColor(red: 243/255, green: 170/255, blue: 96/255, alpha: 1.0)
        case .green: return UIColor(red: 124/255, green: 157/255, blue: 150/255, alpha: 1.0)
        }
    }
        
    static func random(from count: Int) -> UIColor {
        
        // Generate a random index within the range of the enum cases
        let randomIndex = Int.random(in: 0..<count)
        
        // Return the color at the randomly generated index
            return myColor.allCases[randomIndex].associatedColor
    }
 
}
