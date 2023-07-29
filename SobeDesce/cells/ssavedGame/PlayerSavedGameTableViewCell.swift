//
//  PlayerSavedGameTableViewCell.swift
//  SobeDesce
//
//  Created by User on 24/07/2023.
//

import UIKit

class PlayerSavedGameTableViewCell: UITableViewCell {

    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
