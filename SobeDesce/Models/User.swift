//
//  Users.swift
//  SobeDesce
//
//  Created by User on 01/02/2024.
//

import Foundation

struct User: Codable{
    let userUID : String
    let name: String
    var totalGames : Int
    var moneyLost : Float
    var moneyWon : Float
}
