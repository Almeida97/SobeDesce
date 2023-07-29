//
//  CostTableViewCell.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 12/01/2023.
//

import UIKit

class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}

class CostTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerCostLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with player: Player){
        
        playerNameLabel.text = player.name
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
         var cost = player.cost
        if cost < 0 {
            cost = 0
            playerCostLabel.textColor = .white
        }
        if let formattedTipAmount = formatter.string(from: cost as NSNumber) {
            playerCostLabel.text = "\(formattedTipAmount)"
        }
    }
    
}
