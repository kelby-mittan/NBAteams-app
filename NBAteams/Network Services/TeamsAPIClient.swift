//
//  TeamsAPIClient.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct TeamsAPIClient {
    
    static func getTeams(completion: @escaping (Result<[Team],AppError>) -> ()) {
        
        let elementEndpointString = "https://www.balldontlie.io/api/v1/teams"
        
        guard let url = URL(string: elementEndpointString) else {
            completion(.failure(.badURL(elementEndpointString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let teamData = try JSONDecoder().decode(TeamData.self, from: data)
                    let teams = teamData.data
                    completion(.success(teams))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
}
