//
//  Player.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 03/01/2023.
//

import Foundation
import UIKit

struct Player: Codable {
    var name: String
    var rounds: [String] = [" "]
    var totalPoints: [Int] = [25]
    var cost: Double = 0
    var winner: Bool = false
    //var jogou: [Bool] = [true]
}

