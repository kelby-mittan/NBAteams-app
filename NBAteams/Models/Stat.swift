//
//  Stat.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/6/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct StatData: Codable {
    let data: [Stat]
}
struct Stat: Codable {
    let gamesPlayed: Int?
    let playerId: Int?
    let season: Int?
    let min: String
    let fgm: Double
    let fga: Double
    let fg3m: Double
    let fg3a: Double
    let ftm: Double
    let fta: Double
    let oreb: Double
    let dreb: Double
    let reb: Double
    let ast: Double
    let stl: Double
    let blk: Double
    let turnover: Double
    let pf: Double
    let pts: Double
    let fgPct: Double
    let fg3Pct: Double
    let ftPct: Double
    
    enum CodingKeys: String, CodingKey {
        case gamesPlayed = "games_played"
        case playerId = "player_id"
        case season
        case min
        case fgm
        case fga
        case fg3m
        case fg3a
        case ftm
        case fta
        case oreb
        case dreb
        case reb
        case ast
        case stl
        case blk
        case turnover
        case pf
        case pts
        case fgPct = "fg_pct"
        case fg3Pct = "fg3_pct"
        case ftPct = "ft_pct"
    }
    
}

//"data": [
//    {
//        "games_played": 35,
//        "player_id": 192,
//        "season": 2019,
//        "min": "36:34",
//        "fgm": 10.94,
//        "fga": 23.63,
//        "fg3m": 5.06,
//        "fg3a": 13.09,
//        "ftm": 10.34,
//        "fta": 11.97,
//        "oreb": 0.94,
//        "dreb": 4.83,
//        "reb": 5.77,
//        "ast": 7.34,
//        "stl": 1.77,
//        "blk": 0.8,
//        "turnover": 4.46,
//        "pf": 3.17,
//        "pts": 37.29,
//        "fg_pct": 0.463,
//        "fg3_pct": 0.386,
//        "ft_pct": 0.864
//    }
//]
