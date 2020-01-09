//
//  Game.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct GameData: Codable {
    let data: [Game]
}
struct Game: Codable {
    let date: String
    let homeTeam: Team
    let homeTeamScore: Int
    let status: String
    let visitorTeam: Team
    let visitorTeamScore: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case homeTeam = "home_team"
        case homeTeamScore = "home_team_score"
        case status
        case visitorTeam = "visitor_team"
        case visitorTeamScore = "visitor_team_score"
    }
    
    
}



