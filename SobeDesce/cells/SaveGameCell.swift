//
//  SaveGameCell.swift
//  SobeDesce
//
//  Created by User on 20/07/2023.
//

import UIKit

class SaveGameCell: UITableViewCell {
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
