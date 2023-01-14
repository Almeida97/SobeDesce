//
//  PlayerScoreField.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 06/01/2023.
//

import UIKit

class PlayerScoreField: UIView {
    let kCONTENT_XIB_NAME = "PlayerScoreField"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerScoreTf: UITextField!
    @IBOutlet weak var didntPlay: UIButton!
    var didPlay: Bool = true
    
    @IBAction func didntPlayPressed(_ sender: Any) {
        if didPlay {
            didPlay = false
            playerScoreTf.isEnabled = false
            playerScoreTf.text = "Didn´t play this round"
            didntPlay.backgroundColor = .systemRed
        }else{
            didPlay = true
            playerScoreTf.isEnabled = true
            playerScoreTf.text = ""
            didntPlay.backgroundColor = .systemFill
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        didntPlay.layer.cornerRadius = 15
        didntPlay.clipsToBounds = true
        didntPlay.backgroundColor = .systemFill
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
    
