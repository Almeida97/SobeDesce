//
//  AuthService.swift
//  SobeDesce
//
//  Created by User on 28/01/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    public static let shared = AuthService()
    
    private init() {}
    
    
    /// A method to register a new user
    /// - Parameters:
    ///   - email: users email
    ///   - password: users password
    ///   - completion: A completion with two values
    ///   - Bool: wasRegistered - User registered and saved in db
    ///   - Error?: Optional error if firebase throws error
    public func registerUser(name: String, email: String, password: String, completion: @escaping (Bool, Error?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error  {
                completion(false, error)
                return
            }
            
            // save a reference to the user that was just created case i want to save something in firestore
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            let db = Firestore.firestore()
            do {
                try db.collection("users").document(resultUser.uid).setData(from: User(userUID: resultUser.uid, name: name, totalGames: 0, moneyLost: 0, moneyWon: 0))
            } catch {
                print("error saving in user data base but user was created")
            }
            
            completion(true, nil)
        }
    }
    
    
    /// Method to sign in a user
    /// - Parameters:
    ///   - email: Users email
    ///   - password: Users password
    ///   - completion: Completion with one value
    ///   - Error? : Optional error from firebase if it fails to Sign in user
    public func signIn(email: String , password: String, completion: @escaping (Error?)-> Void ) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    /// Method to Sign out user
    /// - Parameter completion: Completion ith optional error if could not sign out
    public func signOut(completion: @escaping (Error?)-> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error  {
            completion(error)
        }
    }
    
    public func checkLoggedIn(completion: @escaping (Bool)-> Void) {
        if Auth.auth().currentUser == nil {
            completion(false)
        } else {
            completion(true)
        }
    }
    
    public func resetPassword(email: String, completion: @escaping (Error?)-> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
                completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userUID)
        docRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                completion(user, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    public func createUserGame(players: [Player], completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        do {
            try db.collection("users").document(userUID).collection("games").addDocument(from: UserGame(players: players, finished: false, created: Date(), userUID: userUID))
            completion(nil)
        } catch {
            completion(nil)
        }
    }

    public func updateUserWinning(winner: Bool, winning: Double, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userUID)
        docRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                if winner {
                    var currentUserWinning = user.moneyWon + Float(winning)
                    db.collection("users").document(userUID).updateData(["moneyWon" : currentUserWinning])
                        completion(nil)
                } else {
                    var currentUserLoses = user.moneyLost + Float(winning)
                    db.collection("users").document(userUID).updateData(["moneyLost" : currentUserLoses])
                        completion(nil)
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
//    public func fetchUserGames(completion: @escaping ([UserGame]?, Error?) -> Void)  {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        var games : [UserGame] = []
//        let db = Firestore.firestore()
//        do {
//            let docRef = try  db.collection("users").document(userUID).collection("games").getDocuments(completion: { snapshot, error in
//                if let error = error {
//                    completion(nil, error)
//                    return
//                }
//                for document in snapshot!.documents {
//                    let game = try document.data(as: UserGame.self)
//                    games.append(game)
//                }
//                completion(games, nil)
//            })
//        } catch {
//            completion(nil, error)
//        }
//
//    }
    
    func getPledgesInProgress(completionHandler: @escaping ([UserGame]) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
      let db = Firestore.firestore()
      var games = [UserGame]() //INITIALISED AS EMPTY

      
        db.collection("users").document(userUID).collection("games")
        .getDocuments { (snapshot, error) in
        guard let snapshot = snapshot, error == nil else {
          //handle error
          return
        }
      
        snapshot.documents.forEach({ (documentSnapshot) in
            do {
                let documentData = try documentSnapshot.data(as: UserGame.self)
              games.append(documentData)
            } catch {
                
            }
            
        })

          // call the completion handler and pass the result array
          completionHandler(games)
      }
    }

}
