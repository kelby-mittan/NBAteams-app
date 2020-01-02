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

//"data": [
//{
//    "id": 62602,
//    "date": "2019-10-25T00:00:00.000Z",
//    "home_team": {
//        "id": 3,
//        "abbreviation": "BKN",
//        "city": "Brooklyn",
//        "conference": "East",
//        "division": "Atlantic",
//        "full_name": "Brooklyn Nets",
//        "name": "Nets"
//    },
//    "home_team_score": 113,
//    "period": 4,
//    "postseason": false,
//    "season": 2019,
//    "status": "Final",
//    "time": "     ",
//    "visitor_team": {
//        "id": 20,
//        "abbreviation": "NYK",
//        "city": "New York",
//        "conference": "East",
//        "division": "Atlantic",
//        "full_name": "New York Knicks",
//        "name": "Knicks"
//    },
//    "visitor_team_score": 109
//},


