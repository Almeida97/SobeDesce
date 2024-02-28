//
//  SaveGameCell.swift
//  SobeDesce
//
//  Created by User on 20/07/2023.
//

import UIKit

class SaveGameCell: UITableViewCell {
    
    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playerListTableView: UITableView!
    
    var players : [Player] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerListTableView.dataSource = self
        playerListTableView.delegate = self
        playerListTableView.register(UINib(nibName: "PlayerSavedGameTableViewCell", bundle: nil), forCellReuseIdentifier: "playerSavedGameCell")
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        playerListTableView.layer.cornerRadius = 8
        playerListTableView.backgroundColor = .secondarySystemBackground
        playerListTableView.layer.masksToBounds = true
        playerListTableView.isUserInteractionEnabled = false;
        myBackgroundView.layer.cornerRadius = 8
        myBackgroundView.clipsToBounds = true
        myBackgroundView.layer.masksToBounds = false
        myBackgroundView.layer.shadowRadius = 5
        myBackgroundView.layer.shadowOpacity = 0.6
        myBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        myBackgroundView.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureTableView(with game: Game) {
        players = CoreDataManager.shared.fetchPlayers(from: game)
        playerListTableView.reloadData()
    }
}

extension SaveGameCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playerListTableView.dequeueReusableCell(withIdentifier: "playerSavedGameCell", for: indexPath) as! PlayerSavedGameTableViewCell
        cell.playerNameLabel.text = players[indexPath.row].name
        cell.playerScoreLabel.text  = "\(String(describing: players[indexPath.row].totalPoints.last!))"
        return cell
    }
}
