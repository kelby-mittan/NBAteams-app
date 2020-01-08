//
//  PlayerAPIClient.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct PlayerAPIClient {
    
    static func getPlayers(for search: String, completion: @escaping (Result<[Player],AppError>) -> ()) {
        
        let playerEndpointString = "https://www.balldontlie.io/api/v1/players?search=\(search)"
        
        guard let url = URL(string: playerEndpointString) else {
            completion(.failure(.badURL(playerEndpointString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let playerData = try JSONDecoder().decode(PlayerData.self, from: data)
                    let players = playerData.data
                    completion(.success(players))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func getPlayerStats(for playerId: Int, completion: @escaping (Result<Stat,AppError>) -> ()) {
        
        let statEndpointString = "https://www.balldontlie.io/api/v1/season_averages?player_ids[]=\(playerId.description)"
        
        guard let url = URL(string: statEndpointString) else {
            completion(.failure(.badURL(statEndpointString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let statData = try JSONDecoder().decode(StatData.self, from: data)
                    let stats = statData.data.first
                    guard let stat = stats else {
                        return
                    }
                    completion(.success(stat))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    
    static func getStatsDated(for playerId: Int, startDate: String, endDate: String, completion: @escaping (Result<[Stat],AppError>) -> ()) {
//         startDate: String, endDate: String,
//        "2019-12-28T00:00:00.000Z"
        
        let statEndpointString = "https://www.balldontlie.io/api/v1/stats?seasons[]=2019&player_ids[]=\(playerId.description)&start_date=\(startDate)&end_date=\(endDate)"
        
//        let statEndpointString = "https://www.balldontlie.io/api/v1/stats?seasons[]=2019&player_ids[]=\(playerId.description)&start_date=\(startDate)&end_date=\(endDate)"
        
        guard let url = URL(string: statEndpointString) else {
            completion(.failure(.badURL(statEndpointString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let statData = try JSONDecoder().decode(StatData.self, from: data)
                    let stats = statData.data
                    completion(.success(stats))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
}
