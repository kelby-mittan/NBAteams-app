//
//  PredictionViewController.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/6/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class PredictionViewController: UIViewController {
    
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var trustPointsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var vsTeamLogo: UIImageView!
    
    var player: Player?
    
    var seasonAvg = Double()
    
    var weekPtAvg = Double()
    
    var weeksStats = [Stat]()
    
    var count = 0.0
    
    var weekSeason = Double()
    
    var newGames = [Game]()
    
    var opposition = 0 {
        didSet {
            // check what team?
            //            loadGames()
            loadThisWeeksPTS()
        }
    }
    
    let goodTeams = [2,7,8,11,13,14,16,17,23,28,29]
    let mehTeams = [3,4,12,15,21,22,27]
    let trashTeams = [1,5,6,9,10,18,19,20,24,25,26,30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGames()
        //loadThisWeeksPTS()
        updateUI()
    }
    
    private func loadGames() {
        
        guard let teamId = player?.team.id else {
            showAlert(title: "Error", message: "Could not get team id.")
            return
        }
        
        GamesAPIClient.getGames(for: teamId) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let games):
                DispatchQueue.main.async {
                    
                    for game in games {
                        if game.status != "Final" {
                            self?.newGames.append(game)
                            self?.newGames = (self?.newGames.sorted { $0.date < $1.date })!
                        }
                    }
                    
                    self?.dateLabel.text = self?.newGames.first?.date.convertISODate()
                    
                    if self?.player?.team.abbreviation != self?.newGames.first?.homeTeam.abbreviation {
                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.homeTeam.abbreviation)!)
                        
                        self?.opposition = (self?.newGames.first?.homeTeam.id)!
                    } else {
                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.visitorTeam.abbreviation)!)
                        
                        self?.opposition = (self?.newGames.first?.visitorTeam.id)!
                    }
                    
                }
            }
        }
    }
    
    private func loadThisWeeksPTS() {
        print("opposition: \(opposition)")
        
        guard let playerId = player?.id else {
            showAlert(title: "Error", message: "Could not get player id.")
            return
        }
        
        PlayerAPIClient.getStatsDated(for: playerId) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let stats):
                DispatchQueue.main.async {
                    
                    for stat in stats {
                        if stat.pts != 0 {
                            self?.weekPtAvg += stat.pts
                            self?.count += 1
                        }
                    }
                    
                    guard let week = self?.weekPtAvg, let count = self?.count, let season = self?.seasonAvg else {
                        return
                    }
                    
                    let avg = (week / count)
                    
                    let seasonWeek = (season + avg) / 2
                    
                    self?.weekSeason = seasonWeek
                    
                    
                    
                    print(seasonWeek)
                    print(count)
                }
            }
        }
        print(opposition.description)
        
    }
    
    func updateUI() {
        //        loadGames()
        playerImage.getImage(with: "https://nba-players.herokuapp.com/players/\(player?.lastName.lowercased() ?? "")/\(player?.firstName.lowercased() ?? "")") { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.playerImage.image = UIImage(named: "nbaLogo")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.playerImage.image = image
                }
            }
        }
        trustPointsLabel.text = seasonAvg.description
    }
    
}


//    private func loadGames() {
//        GamesAPIClient.getGames(for: (player?.team.id)!) { [weak self] (result) in
//            switch result {
//            case .failure(let appError):
//                DispatchQueue.main.async {
//                    self?.showAlert(title: "Error", message: "\(appError)")
//                }
//            case .success(let games):
//                DispatchQueue.main.async {
//                    self?.newGames = games.sorted { $0.date < $1.date }
//
//                    for game in games {
//                        if game.status != "Final" {
//                            self?.newGames.append(game)
//                            self?.newGames = (self?.newGames.sorted { $0.date < $1.date })!
//                        }
//                    }
//
//                    self?.dateLabel.text = self?.newGames.first?.date.convertISODate()
//
//                    if self?.player?.team.abbreviation != self?.newGames.first?.homeTeam.abbreviation {
//                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.homeTeam.abbreviation)!)
//
//                        self?.opposition = (self?.newGames.first?.homeTeam.id)!
//
//                    } else {
//                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.visitorTeam.abbreviation)!)
//
//                        self?.opposition = (self?.newGames.first?.visitorTeam.id)!
//
//                    }
//
//                }
//            }
//        }
//    }
