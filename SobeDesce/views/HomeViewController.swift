//
//  HomeViewController.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 30/12/2022.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var recentLabel: UIButton!
    @IBOutlet weak var textfieldStack: UIStackView!
    @IBOutlet weak var addPlayerBtn: UIButton!
    @IBOutlet weak var removePlayerBtn: UIButton!
    @IBOutlet weak var startGameBtn: UIButton!
    var players: [Player] = []
    var tag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecentButton()
        recentLabel.layer.borderWidth = 2
        recentLabel.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        recentLabel.layer.cornerRadius = 10
        
        self.setupToHideKeyboardOnTapView()
        addFields()
    }

    func configureRecentButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .done, target: self, action: #selector(navigateToRecentVC))
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        
    }
    
    @objc func navigateToRecentVC(){
        self.performSegue(withIdentifier: "showRecentSegue", sender: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        players = []
        removePlayerBtn.isHidden = true
        startGameBtn.isEnabled = false
        for item in 0..<textfieldStack.arrangedSubviews.count {
            var tf = textfieldStack.subviews[item] as! UITextField
            tf.text = ""
            
        }
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
    
    func addFields() {
        for _ in 0..<3 {
            addField(toView: self.textfieldStack, tag: tag)
            tag+=1
        }
      }
      
    func addField(toView view: UIStackView, tag: Int) {
        let playerName =  UITextField()
        playerName.placeholder = "Player name"
        playerName.borderStyle = UITextField.BorderStyle.roundedRect
        playerName.delegate = self
        playerName.keyboardType = .default
        playerName.tag = tag
        view.addArrangedSubview(playerName)
        playerName.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                       for: .editingChanged)
        let margins = view.layoutMarginsGuide
        playerName.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        playerName.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20).isActive = true
        
      }
    
    @objc func textFieldsIsNotEmpty() {
        var shouldBeEnabled = false
        for index in 1...tag-1 {
             let tf = view.viewWithTag(index) as! UITextField
            guard let name = tf.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
                shouldBeEnabled = false
                break
            }
            shouldBeEnabled = true
        }
        if shouldBeEnabled == true {
            startGameBtn.isEnabled = true
        }else{
            startGameBtn.isEnabled = false
        }
       }
    
    func removeField(toView view: UIStackView, tag: Int){
        let fieldToRemove = view.viewWithTag(tag)!
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            fieldToRemove.removeFromSuperview()
        })
    }
    
    func setView(view: UIView, hidden: Bool) {
        if hidden {
            UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                view.isHidden = hidden
            })
        }else{
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                view.isHidden = hidden
            })
        }
    }
    
    @IBAction func addPlayerPressed(_ sender: Any) {
        if tag < 6 {
            addField(toView: self.textfieldStack, tag: tag)
            tag+=1
        }
        if tag > 3 {
            setView(view: removePlayerBtn, hidden: false)
        }
        if tag == 6 {
            setView(view: addPlayerBtn, hidden: true)
        }
        textFieldsIsNotEmpty()
    }
    
    @IBAction func removePlayerPressed(_ sender: Any) {
            self.tag-=1
            removeField(toView: self.textfieldStack, tag: self.tag)
        if tag <= 4 {
            setView(view: removePlayerBtn, hidden: true)
            setView(view: addPlayerBtn, hidden: false)
        }
        if tag >= 5 {
            setView(view: removePlayerBtn, hidden: false)
            setView(view: addPlayerBtn, hidden: false)
        }
        textFieldsIsNotEmpty()
    }
    
    func startGamePressed(){
        for index in 1...tag-1 {
            let textfield = view.viewWithTag(index) as! UITextField
            guard let playername = textfield.text, !playername.isEmpty else {
                continue
            }
            players.append(Player(name: playername))
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        startGamePressed()
        if segue.identifier == "startGameSegue" {
            let gameScreen: ViewController = segue.destination as! ViewController
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            let currentDate = dateFormatter.string(from: Date())
            let uuid = UUID().uuidString
            CoreDataManager.shared.createGame(withName: "\(uuid)", players: self.players, dateCreated: currentDate)
            gameScreen.players = self.players
            gameScreen.gameName = uuid
        }
        if segue.identifier == "showRecentSegue" {
            let savedGameScreen: SavedGamesViewController = segue.destination as! SavedGamesViewController
        }
    }

    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
