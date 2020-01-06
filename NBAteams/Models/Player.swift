//
//  Player.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct PlayerData: Codable {
    let data: [Player]
}
struct Player: Codable {
    let id: Int
    let firstName: String
    let heightFeet: Int?
    let heightInches: Int?
    let lastName: String
    let position: String
    let team: Team
    let weightPounds: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case heightFeet = "height_feet"
        case heightInches = "height_inches"
        case lastName = "last_name"
        case position
        case team
        case weightPounds = "weight_pounds"
    }
    
}

//"data": [
//{
//    "id": 797,
//    "first_name": "Thomas",
//    "height_feet": null,
//    "height_inches": null,
//    "last_name": "Jordan",
//    "position": "",
//    "team": {
//        "id": 23,
//        "abbreviation": "PHI",
//        "city": "Philadelphia",
//        "conference": "East",
//        "division": "Atlantic",
//        "full_name": "Philadelphia 76ers",
//        "name": "76ers"
//    },
//    "weight_pounds": null
