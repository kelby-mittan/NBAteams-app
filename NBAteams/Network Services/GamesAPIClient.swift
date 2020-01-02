//
//  GamesAPIClient.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct GamesAPIClient {
    
    static func getGames(for teamId: Int, completion: @escaping (Result<[Game],AppError>) -> ()) {
        
        let gameEndpointString = "https://www.balldontlie.io/api/v1/games?seasons[]=2019&team_ids[]=\(teamId.description)&per_page=82"
        
        guard let url = URL(string: gameEndpointString) else {
            completion(.failure(.badURL(gameEndpointString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let gameData = try JSONDecoder().decode(GameData.self, from: data)
                    let games = gameData.data
                    completion(.success(games))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
