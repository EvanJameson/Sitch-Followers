//
//  PersistenceManager.swift
//  Sitch
//
//  Created by Evan Jameson on 7/16/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import Foundation


enum PersistenceActionType {
    case add, remove
}


enum PersistenceManager {
    static private let defaults         = UserDefaults.standard
    enum keys { static let favorites    = "favorites" }
    
    
    /// updates UserDefaults with the specified user by either adding them or removing them from favorites
    /// - Parameters:
    ///   - favorite: user to be saved or removed from favorites
    ///   - actionType: add or remove
    ///   - completed: completion handler/closure that returns an error or nil
    static func updateWith(favorite: User, actionType: PersistenceActionType, completed: @escaping(SError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    /// Retrieves a list of User objects from the favorites in UserDefaults
    /// - Parameter completed: completion handler/closure that returns the favorites or an error
    static func retrieveFavorites(completed: @escaping(Result<[User], SError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder     = JSONDecoder()
            let favorites   = try decoder.decode([User].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    
    /// Saves the list of User objects it is given to favorites in UserDefaults
    /// - Parameter favorites: list of Users to save
    /// - Returns: returns a  list an error or nil
    static func save(favorites: [User]) -> SError? {
        do {
            let encoder             = JSONEncoder()
            let encodedFavorites    = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
