//
//  NetworkManager.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared       = NetworkManager()
    private let baseURL     = "https://api.twitch.tv/helix/"
    let followersPerPage    = Limits.followersPerPage
    let streamsPerPage      = Limits.streamsPerPage
    let cache               = NSCache<NSString, UIImage>()

    
    private init () {}
    
    
    // MARK: - Data Network Calls
    
    
    /// Makes an API request for a single users data.
    /// The response is decoded into a single key with an array of one User object
    /// which is taken out and sent to the caller via the completion handler
    /// - Parameters:
    ///   - username: used to build the endpoint to search for a specific user
    ///   - completed: completion handler/closure that returns a Result Type
    func getUser(for username: String, completed: @escaping (Result<User, TFError>) -> Void) {
        let endpoint = baseURL + "users?login=\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaders.clientID, forHTTPHeaderField: "Client-ID")
        request.addValue(HTTPHeaders.auth, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder     = JSONDecoder()
                let userWrapper = try decoder.decode(UserWrapper.self, from: data)
                
                if userWrapper.data.isEmpty {
                    completed(.failure(.invalidUsername))
                    return
                }
                
                let user = userWrapper.data[0]
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    /// Makes an API request for a single users followers.
    /// The response is decoded into a FollowerWrapper which contains
    /// all the necessary info and sent to the caller via the completion handler
    /// - Parameters:
    ///   - id: id number of user we are getting the followers for
    ///   - paginationCursor: an optional value which specifies the pagination mark for the next set of followers
    ///   - completed: completion handler/closure that returns a Result Type
    func getFollowers(for id: String, paginationCursor: String?, completed: @escaping (Result<FollowerWrapper, TFError>) -> Void) {
        var endpoint = baseURL + "users/follows?to_id=\(id)&first=\(followersPerPage)"
        
        if let pagination = paginationCursor {
            endpoint += "&after=\(pagination)"
        }
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaders.clientID, forHTTPHeaderField: "Client-ID")
        request.addValue(HTTPHeaders.auth, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
          
            do {
                let decoder         = JSONDecoder()
                let followerWrapper = try decoder.decode(FollowerWrapper.self, from: data)
                completed(.success(followerWrapper))
            } catch {
                completed(.failure(.noFollowers))
            }
        }
        
        task.resume()
    }
    
    
    /// Makes an API request for a users channel. The response is decoded
    /// into a ChannelWrapper which contains a list of possible channels.
    /// Only the channel with the matching username is returned
    /// - Parameters:
    ///   - username: username of desired channel
    ///   - completed: completion handler/closure that returns a Result Type
    func getChannel(for username: String, completed: @escaping (Result<Channel, TFError>) -> Void) {
        let endpoint = baseURL + "search/channels?query=\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaders.clientID, forHTTPHeaderField: "Client-ID")
        request.addValue(HTTPHeaders.auth, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
          
            do {
                let decoder         = JSONDecoder()
                let channelWrapper  = try decoder.decode(ChannelWrapper.self, from: data)
                
                for channel in channelWrapper.data {
                    if (channel.display_name.lowercased() == username.lowercased()) {
                        completed(.success(channel))
                        return
                    }
                }
                completed(.failure(.invalidUsername))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    /// Makes an API request for a specified game. The response is decoded
    /// into a GameWrapper which is further unwrapped for its nested Game
    /// object. The box art url is then given a specified width and height.
    /// - Parameters:
    ///   - id: id number of the specified game
    ///   - completed: completion handler/closure that returns a Result Type
    func getGameInfo(for id: String, completed: @escaping (Result<Game, TFError>) -> Void) {
        let endpoint = baseURL + "games?id=\(id)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidGame))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaders.clientID, forHTTPHeaderField: "Client-ID")
        request.addValue(HTTPHeaders.auth, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder     = JSONDecoder()
                let gameWrapper = try decoder.decode(GameWrapper.self, from: data)
                
                if gameWrapper.data.isEmpty {
                    completed(.failure(.invalidGame))
                    return
                }
                
                var game            = gameWrapper.data[0]
                game.box_art_url    = game.box_art_url.replacingOccurrences(of: "{width}", with: "52")
                game.box_art_url    = game.box_art_url.replacingOccurrences(of: "{height}", with: "72")
                
                completed(.success(game))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    /// Makes an API request for the current top streams. The response is decoded
    /// into a StreamWrapper which is reutrned via a completion handler
    /// - Parameters:
    ///   - paginationCursor: an optional value which specifies the pagination mark for the next set of streams
    ///   - completed: completion handler/closure that returns a Result Type
    func getStreams(paginationCursor: String?, completed: @escaping (Result<StreamWrapper,TFError>) -> Void) {
        var endpoint = baseURL + "streams?first=\(streamsPerPage)"
        
        if let pagination = paginationCursor {
            endpoint += "&after=\(pagination)"
        }
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidData))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaders.clientID, forHTTPHeaderField: "Client-ID")
        request.addValue(HTTPHeaders.auth, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder         = JSONDecoder()
                let streamWrapper   = try decoder.decode(StreamWrapper.self, from: data)
                completed(.success(streamWrapper))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Download Images
    
    
    /// Downloads the avatar image of a user with the specified url. Is returned via completion handler.
    /// - Parameters:
    ///   - urlString: url of image
    ///   - user: username used to cache image
    ///   - completed: completion handler/closure that returns an image or nil
    func downloadAvatarImage(from urlString: String, for user: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: user)
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self      = self,
                error == nil,
                let response    = response as? HTTPURLResponse, response.statusCode == 200,
                let data        = data,
                let image       = UIImage(data: data)
                else {
                    completed(nil)
                    return
                }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            completed(image)
        }
        
        task.resume()
    }
    
    
    /// Downloads the thumbnail image of a stream with the specified url. Is returned via completion handler.
    /// - Parameters:
    ///   - urlString: url of image
    ///   - completed: completion handler/closure that returns an image or nil
    func downloadTumbnailImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey    = NSString(string: urlString)
        
        var scaleUrl    = urlString
        scaleUrl        = urlString.replacingOccurrences(of: "{width}", with: "500")
        scaleUrl        = scaleUrl.replacingOccurrences(of: "{height}", with: "282")
        
        guard let url = URL(string: scaleUrl) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self      = self,
                error == nil,
                let response    = response as? HTTPURLResponse, response.statusCode == 200,
                let data        = data,
                let image       = UIImage(data: data)
                else {
                    completed(nil)
                    return
                }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            completed(image)
        }
        
        task.resume()
    }
    
    
    /// Downloads the box art image of a game with the specified url. Is returned via completion handler.
    /// - Parameters:
    ///   - urlString: url of image
    ///   - game: name of game used to cache image
    ///   - completed: completion handler/closure that returns an image or nil
    func downloadGameImage(from urlString: String, for game: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: game)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self      = self,
                error == nil,
                let response    = response as? HTTPURLResponse, response.statusCode == 200,
                let data        = data,
                let image       = UIImage(data: data)
                else {
                    completed(nil)
                    return
                }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            completed(image)
        }
        
        task.resume()
    }
}
