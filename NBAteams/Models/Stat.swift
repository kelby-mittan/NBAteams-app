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

