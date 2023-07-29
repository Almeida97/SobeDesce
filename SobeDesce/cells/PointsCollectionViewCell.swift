//
//  PointsCollectionViewCell.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 23/12/2022.
//

import UIKit

class PointsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pointsPerRoundLabelBackground: UIView!
    @IBOutlet weak var totalPointsLabelBackground: UIView!
    @IBOutlet var pointsPerRoundLabel: UILabel!
    @IBOutlet var totalPointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.cornerRadius = (self.frame.size.height / 2)
        totalPointsLabelBackground.layer.masksToBounds = true
        totalPointsLabelBackground.layer.cornerRadius = (totalPointsLabelBackground.frame.size.width / 2)
        pointsPerRoundLabelBackground.layer.masksToBounds = true
        pointsPerRoundLabelBackground.layer.cornerRadius = (pointsPerRoundLabelBackground.frame.size.width / 2)
        // Initialization code
    }

}
