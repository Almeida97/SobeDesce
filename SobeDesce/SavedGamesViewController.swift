//
//  SavedGamesViewController.swift
//  SobeDesce
//
//  Created by User on 20/07/2023.
//

import UIKit
import CoreData

class SavedGamesViewController: UIViewController {
    var players: [Player] = []
    var gameName: String = ""
    @IBOutlet weak var recentGamesTable: UITableView!
    let viewContext = CoreDataManager.shared.persistentContainer.viewContext
    var recentGames: [Game]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentGamesTable.delegate = self
        recentGamesTable.dataSource = self
        recentGamesTable.register(UINib(nibName: "SaveGameCell", bundle: nil), forCellReuseIdentifier: "saveGameCell")
        // Do any additional setup after loading the view.
        recentGames = CoreDataManager.shared.fetchAllGames()
        recentGamesTable.reloadData()
    }

}

extension SavedGamesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentGames?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveGameCell", for: indexPath) as! SaveGameCell
        cell.gameLabel.text = recentGames?[indexPath.row].name
        //cell.dateLabel.text = recentGames?[indexPath.row].gameDate
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentGame = CoreDataManager.shared.fetchGame(withName: recentGames?[indexPath.row].name ?? "random")
        self.gameName = (currentGame?.name)!
        if let savedPlayers = currentGame?.players?.allObjects as? [PlayerEnt] {
            
            for savedPlayer in savedPlayers {
                players.append(Player(name: savedPlayer.name!, rounds: savedPlayer.rounds!, totalPoints: savedPlayer.totalPoints!, cost: savedPlayer.cost, winner: savedPlayer.winner))
            }
            
        }

        performSegue(withIdentifier: "openSavedGame", sender: Any?.self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let currentGame = CoreDataManager.shared.fetchGame(withName: recentGames?[indexPath.row].name ?? "random")
            recentGames?.remove(at: indexPath.row)
            CoreDataManager.shared.deleteGame(currentGame!)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openSavedGame" {
            let gameScreen: ViewController = segue.destination as! ViewController
            gameScreen.players = self.players
            gameScreen.gameName = self.gameName
        }
    }
}
