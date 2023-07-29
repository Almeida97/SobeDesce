//
//  WinnerViewController.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 03/01/2023.
//

import UIKit

class WinnerViewController: UIViewController {

    @IBOutlet weak var winnerTableView: UITableView!
    @IBOutlet weak var newGameBtn: UIButton!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    var players: [Player] = []
    var gameName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.sizeToFit()
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        winnerTableView.delegate = self
        winnerTableView.dataSource = self
        winnerTableView.backgroundColor = UIColor.clear
        winnerTableView.sizeToFit()
        winnerTableView.register(UINib(nibName: "CostTableViewCell", bundle: nil), forCellReuseIdentifier: "costCell")
        if let winner = players.firstIndex(where: { $0.totalPoints.last! <= 0 }) {
            let winnerPlayer = players.remove(at: winner)
            winnerLabel.text =  "Winner is \(winnerPlayer.name)"

        }
        
    }
    
    @IBAction func newGameBtnPressed(_ sender: Any) {
        if let thisGame = CoreDataManager.shared.fetchGame(withName: gameName) {
            CoreDataManager.shared.deleteGame(thisGame)
        }
    }
}

extension WinnerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "costCell", for: indexPath) as! CostTableViewCell
        cell.configure(with: players[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
