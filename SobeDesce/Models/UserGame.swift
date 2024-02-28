//
//  Game.swift
//  SobeDesce
//
//  Created by User on 07/02/2024.
//

import Foundation

struct UserGame : Codable {
    var players : [Player]
    var finished : Bool
    let created : Date
    let userUID : String
}
