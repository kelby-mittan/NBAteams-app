//
//  GameCell.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet var oppositionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var vsAtLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var oppositionImage: UIImageView!
    
    var selectedTeamId: Int?
    
    func configureCell(for game: Game) {
        
        let theDate = game.date.convertISODate()
        dateLabel.text = theDate.components(separatedBy: ",").first
        statusLabel.text = game.status
        
        if selectedTeamId == game.homeTeam.id {
            oppositionLabel.text = game.visitorTeam.full_name
            vsAtLabel.text = "VS"
            oppositionImage.image = UIImage(named: game.visitorTeam.abbreviation)
            if game.homeTeamScore > game.visitorTeamScore {
                scoreLabel.text = "WIN, \(game.homeTeamScore)-\(game.visitorTeamScore)"
            } else if game.homeTeamScore < game.visitorTeamScore {
                scoreLabel.text = "Loss, \(game.visitorTeamScore)-\(game.homeTeamScore)"
            } else {
                scoreLabel.text = ""
            }
        } else {
            oppositionLabel.text = game.homeTeam.full_name
            vsAtLabel.text = "@"
            oppositionImage.image = UIImage(named: game.homeTeam.abbreviation)
            if game.homeTeamScore > game.visitorTeamScore {
                scoreLabel.text = "Loss, \(game.homeTeamScore)-\(game.visitorTeamScore)"
            } else if game.homeTeamScore < game.visitorTeamScore {
                scoreLabel.text = "Win, \(game.visitorTeamScore)-\(game.homeTeamScore)"
            } else {
                scoreLabel.text = ""
            }
        }
        
    }
}
