//
//  PlayerCell.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet var teamLabel: UILabel!
    @IBOutlet var teamImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    
    func configureCell(for player: Player) {
        teamLabel.text = player.team.name
        teamImage.image = UIImage(named: player.team.abbreviation)
        nameLabel.text = "\(player.lastName), \(player.firstName)"
        
        if !player.position.isEmpty {
            positionLabel.text = "Position: \(player.position)"
        } else {
            positionLabel.text = "Position: N/A"
        }
        
        guard let feet = player.heightFeet, let inches = player.heightInches else {
            heightLabel.text = "Height: N/A"
            return
        }
        heightLabel.text = "Height: \(feet.description)' \(inches.description)"
        
//        if player.heightFeet == nil || player.heightInches == nil {
//            heightLabel.text = "Height: N/A"
//        } else {
//            heightLabel.text = "Height: \(player.heightFeet ?? )' \(player.heightInches)\""
//        }
        
    }
    
}
