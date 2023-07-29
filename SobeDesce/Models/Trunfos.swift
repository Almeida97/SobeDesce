//
//  Trunfos.swift
//  SobeDesce
//
//  Created by User on 29/07/2023.
//

import Foundation

enum Trunfos: Int{
    case outro
    case paus
    case copas
    case copasEscuras
   
    var trunfoValue: Int {
        switch self {
        case .outro:
          return 1

        case .copas:
          return 2

        case .copasEscuras:
          return 3

        case .paus:
          return 1

        default:
          break
        }
      }
    
}

