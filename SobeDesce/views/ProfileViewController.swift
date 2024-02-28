//
//  ProfileViewController.swift
//  SobeDesce
//
//  Created by User on 29/01/2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moneyWonLabel: UILabel!
    @IBOutlet weak var moneyLostLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.navigationItem.title = "Profile"
        self.navigationItem.largeTitleDisplayMode = .always
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                return
            }
            self.activityIndicator.stopAnimating()
            if let user = user {
                self.nameLabel.text = user.name
                let currentBalance = user.moneyWon - user.moneyLost
                if currentBalance < 0 {
                    self.balanceLabel.textColor = .systemRed
                }
                self.balanceLabel.text = "Balance: \(currentBalance) €"
                self.moneyWonLabel.text = "Money won: \(user.moneyWon) €"
                self.moneyLostLabel.text = "Money lost: \(user.moneyLost) €"
                self.gamesPlayedLabel.text = "Total games: \(user.totalGames)"
            }
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "unwindToSignIn", sender: nil)
        } catch {
            print("error ")
        }
    }
}
