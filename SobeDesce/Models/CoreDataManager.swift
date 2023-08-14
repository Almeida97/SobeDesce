//
//  CoreDataManager.swift
//  SobeDesce
//
//  Created by User on 20/07/2023.
//

import Foundation
import CoreData


struct CoreDataManager {
    
    static let shared = CoreDataManager()
    var gameName : String = ""

    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SobeDesce")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed")
            }
        }
        return container
    }()

    func fetchPlayers(from game: Game) -> [Player]{
        var players: [Player] = []
        if let savedPlayers = game.players?.allObjects as? [PlayerEnt] {
            for savedPlayer in savedPlayers {
                players.append(Player(name: savedPlayer.name!, rounds: savedPlayer.rounds!, totalPoints: savedPlayer.totalPoints!, cost: savedPlayer.cost, winner: savedPlayer.winner))
            }
            
        }
        return players
    }
    func createGame(withName gameName: String, players: [Player], dateCreated: String) {
        let context = persistentContainer.viewContext
        let game = NSEntityDescription.insertNewObject(forEntityName: "Game", into: context) as! Game
        game.name = gameName
        game.gameDate = dateCreated
        for player in players {
            let playerToSave = NSEntityDescription.insertNewObject(forEntityName: "PlayerEnt", into: context) as! PlayerEnt
            playerToSave.name = player.name
            playerToSave.rounds = player.rounds
            playerToSave.totalPoints = player.totalPoints
            playerToSave.cost = player.cost
            playerToSave.winner = player.winner
            game.addToPlayers(playerToSave)
        }
        
        do {
            try context.save()
            return
        } catch let createError {
            print("Failed to create: \(createError)")
        }
        return
    }
    
    func fetchAllGames() -> [Game]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
        
        do {
            let games = try context.fetch(fetchRequest)
            return games
        } catch let fetchError {
            print("Failed to fetch Games \(fetchError)")
        }
        return nil
    }
    
    func updatePlayerData(from gameName: String , players: [Player]) {
        let context = persistentContainer.viewContext
        let game = fetchGame(withName: gameName)
        let savedPlayers = game?.players?.allObjects as! [PlayerEnt]
        for player in players {
            var playerToSave = savedPlayers.first { wherePlayer in
                wherePlayer.name == player.name
            }
            if playerToSave != nil {
                playerToSave!.rounds = player.rounds
                playerToSave!.totalPoints = player.totalPoints
                playerToSave!.cost = player.cost
                playerToSave!.winner = player.winner
            }
            }
        
        do {
            try context.save()
        } catch let createError {
            print("Failed to create: \(createError)")
        }
    }
    
    func fetchGame(withName name: String) -> Game? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@ ", name)
        
        do {
            let games = try context.fetch(fetchRequest)
            return games.first
        } catch let fetchError {
            print("Failed to fetch Games \(fetchError)")
        }
        return nil
    }
    
    func deleteGame(_ game: Game) {
        let context = persistentContainer.viewContext
        context.delete(game)
        do {
            try context.save()
        } catch let saveError {
            print("Failed to fetch Games \(saveError)")
        }
    }
    
    func addPlayer(game: Game, players: [Player]) {
        let context = persistentContainer.viewContext
        for player in players {
            let playerToSave = NSEntityDescription.insertNewObject(forEntityName: "PlayerEnt", into: context) as! PlayerEnt
            playerToSave.name = player.name
            playerToSave.rounds = player.rounds
            playerToSave.totalPoints = player.totalPoints
            playerToSave.cost = player.cost
            playerToSave.winner = player.winner
            game.addToPlayers(playerToSave)
        }
        
        do {
            try context.save()
        } catch let createError {
            print("Failed to create: \(createError)")
        }
    }
    
}
