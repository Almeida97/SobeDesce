//
//  ViewController.swift
//  SobeDesce
//
//  Created by PAULO ALMEIDA on 21/12/2022.
//

import UIKit

class ViewController: UIViewController, MyDataSendingDelegateProtocol {
    @IBOutlet weak var scoreTableView: UITableView!
    @IBOutlet weak var endRoundBtn: UIButton!
    @IBOutlet var viewBackground: UIView!
    var players: [Player] = []
    var gameName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        scoreTableView.register(UINib(nibName: "PointsCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    
    func sendDataToFirstViewController(roundScoreArray: [String],trunfo: Trunfos) {
        var num = 0
        for round in roundScoreArray {
            let currentPLayer = self.players[num]
            let playerTotalPoints = currentPLayer.totalPoints.count-1
            if round == "-" {
                self.players[num].rounds.append("-")
                //self.players[num].roundColor.append(.green)
                self.players[num].totalPoints.append(currentPLayer.totalPoints[playerTotalPoints])
            }else{
                if (Int(round) == 0) {
                    self.players[num].rounds.append("\(5 * trunfo.trunfoValue)")
                    let newScore = currentPLayer.totalPoints[playerTotalPoints] + (5 * trunfo.trunfoValue)
                   //self.players[num].roundColor.append(.red)
                    self.players[num].totalPoints.append(newScore)
                }else{
                    self.players[num].rounds.append("\(Int(round)! * trunfo.trunfoValue)")
                    let newScore = currentPLayer.totalPoints[playerTotalPoints] - (Int(round)! * trunfo.trunfoValue)
                   //self.players[num].roundColor.append(.green)
                    self.players[num].totalPoints.append(newScore)
                }
            }
            
            num+=1
        }
        self.scoreTableView.reloadData()
        CoreDataManager.shared.updatePlayerData(from: self.gameName, players: self.players)
        self.checkScore()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getScores" {
            let secondVC: ScoreViewController = segue.destination as! ScoreViewController
            secondVC.players = self.players
            secondVC.delegate = self
        }
        if segue.identifier == "showWinner" {
            let winnerVC: WinnerViewController = segue.destination as! WinnerViewController
            winnerVC.players = self.players
            winnerVC.gameName = self.gameName
        }
    }
    
    func newGame() {
        for i in 0 ..< players.count {
            players[i].totalPoints = [25]
            players[i].rounds = [" "]
            players[i].cost = 0
            players[i].winner = false
        }
    }
    
    func checkScore()-> Bool {
        if let winner = players.firstIndex(where: { $0.totalPoints.last! <= 0 }) {
            players[winner].winner = true
            var costLabel = ""
            for i in 0 ..< players.count {
                if !(players[i].winner){
                    players[i].cost = Double(players[i].totalPoints.last!) * 0.05
                    costLabel += " \(players[i].name) owes \(players[i].cost)"
                }
                endRoundBtn.isEnabled = false
            }
            return true
        }
        return false
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PointsCell
        cell.configure(with: players[indexPath.row])
        cell.scrollLast()
        cell.playerLabel.text = players[indexPath.row].name
        return cell
    }
}
