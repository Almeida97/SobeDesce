//
//  ScoreViewController.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 29/12/2022.
//

import UIKit

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

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(roundScoreArray: [String], trunfo: Trunfos)
    func checkScore()->Bool
}

class ScoreViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var espadaButton: UIButton!
    @IBOutlet weak var copasButton: UIButton!
    @IBOutlet weak var copasEscuras: UIButton!
    @IBOutlet weak var tfStack: UIStackView!
    @IBOutlet var viewBack: UIView!
    @IBOutlet weak var backgroundView: UIView!
    var delegate: MyDataSendingDelegateProtocol? = nil
    var trunfo: Trunfos?
    var players: [Player] = []
    var gameName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapView()
        addFields(view: self.tfStack, players: self.players)
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
    }
    
    func addFields(view: UIStackView, players: [Player]) {
        var tag = 1
        for player in players {
            addField(toView: view, playerName: "\(player.name)", tag: tag)
            tag+=1
        }
      }
      
    func addField(toView view: UIStackView, playerName: String, tag: Int) {
        let playScoreView = PlayerScoreField()
        playScoreView.playerScoreTf.placeholder = "\(playerName) points"
        playScoreView.tag = tag
        view.addArrangedSubview(playScoreView)
      }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1

        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    
    @IBAction func changeTrunfo(sender: AnyObject) {
        var shouldHide: Bool
        guard let button = sender as? UIButton else {
            return
        }
        let allButtonTags = [100, 101, 102,103]
        let currentButtonTag = sender.tag
        button.borderAnimation(show: true)
        allButtonTags.filter ({ $0 != currentButtonTag }).forEach { tag in
                if let button = self.view.viewWithTag(tag) as? UIButton {
                    // Deselect/Disable these buttons
                    button.borderAnimation(show: false)
                }
        }
        switch button.tag {
        case 100:
            trunfo = .outro
            shouldHide = false
        case 101:
            trunfo = .copas
            shouldHide = false
        case 102:
            trunfo = .copasEscuras
            shouldHide = false
        case 103:
            trunfo = .paus
            shouldHide = true
        default:
            trunfo = .outro
            return
        }
        subViewsFromShouldShow(view: tfStack, should: shouldHide)
    }
    
    func subViewsFromShouldShow(view: UIView, should: Bool) {
        for subView in view.subviews {
            let subView = subView as! PlayerScoreField
            subView.didPlay = false
            subView.didntPlayPressed(subView)
            subView.didntPlay.isHidden = should
        }
    }
    
    @IBAction func sendScoreData(_ sender: Any) {
        var dataToBeSent: [String] = []
        for index in 0...players.count {
            if let playerView = self.view.viewWithTag(index) as? PlayerScoreField {
                if playerView.didPlay {
                    if let theTextField = playerView.playerScoreTf {
                        guard let score = theTextField.text?.filter(\.isWholeNumber), !score.isEmpty else {
                            dataToBeSent.append("0")
                            continue
                        }
                        dataToBeSent.append("\(score)")
                    }
                }else{
                    dataToBeSent.append("-")
                }
            }
        }
        if self.delegate != nil {
            self.delegate?.sendDataToFirstViewController(roundScoreArray: dataToBeSent, trunfo: trunfo ?? Trunfos.outro)
            weak var pvc:UIViewController! = self.presentingViewController?.children[1]
              dismiss(animated: true)
            {
                let winnerExists = self.delegate?.checkScore()
                if (winnerExists ?? false)
                  {
                    pvc.performSegue(withIdentifier: "showWinner", sender: nil)
                    
                  }
                
              }
        }
    }
}

extension UIViewController {
    
    func setupToHideKeyboardOnTapView(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

}
extension UIButton {
    func borderAnimation(show: Bool) {
        let border = CALayer()
        border.name = "border"
        border.frame = CGRect(x: 0, y: self.frame.size.height - 5, width:  10, height: self.frame.size.height)
        border.borderWidth = 5
        border.borderColor = UIColor.white.cgColor
        if show {
            let positionAnimation = CABasicAnimation(keyPath: "bounds.size.width")
            positionAnimation.fromValue =  0
            positionAnimation.toValue =   self.frame.size.width
            positionAnimation.duration = 0.5
            // MARK: Add Animation to Layer
            border.add(positionAnimation, forKey: "bounds.size.width")
            self.layer.addSublayer(border)
            border.frame.size.width = self.frame.size.width
            self.layer.masksToBounds = true
        }else{
            self.layer.sublayers?.forEach({ (layer) in
                if layer.name == "border" {
                    layer.removeFromSuperlayer()
                    }
            })
        }
    }
}
