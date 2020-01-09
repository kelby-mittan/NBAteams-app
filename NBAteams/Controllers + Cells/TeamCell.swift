//
//  TeamCell.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var teamLogo: UIImageView!
    
    
    func configureCell(for team: Team) {
        
        teamLogo.layer.cornerRadius = 35
        
        cityLabel.text = team.city
        
        teamLogo.image = UIImage(named: team.abbreviation)
    }
    
}
