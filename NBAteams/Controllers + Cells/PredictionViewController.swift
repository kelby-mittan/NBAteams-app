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
    
//    var opposition = Int() {
//        didSet {
//            GamesAPIClient.getGames(for: (player?.team.id)!) { [weak self] (result) in
//                switch result {
//                case .failure(let appError):
//                    DispatchQueue.main.async {
//                        self?.showAlert(title: "Error", message: "\(appError)")
//                    }
//                case .success(let games):
//                    DispatchQueue.main.async {
//
//                        for game in games {
//                            if game.status != "Final" {
//                                self?.newGames.append(game)
//                                self?.newGames = (self?.newGames.sorted { $0.date < $1.date })!
//                            }
//                        }
//
//                        if self?.player?.team.abbreviation != self?.newGames.first?.homeTeam.abbreviation {
//                            self?.opposition = (self?.newGames.first?.homeTeam.id)!
//                        } else {
//                            self?.opposition = (self?.newGames.first?.visitorTeam.id)!
//                        }
//
//                    }
//                }
//            }
//        }
//    }
    
    let goodTeams = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    let mehTeams = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    let trashTeams = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGames()
        loadThisWeeksPTS()
        updateUI()
    }
    
    private func loadGames() {
        GamesAPIClient.getGames(for: (player?.team.id)!) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let games):
                DispatchQueue.main.async {
                    //                    self?.games = games.sorted { $0.date < $1.date }
                    
                    for game in games {
                        if game.status != "Final" {
                            self?.newGames.append(game)
                            self?.newGames = (self?.newGames.sorted { $0.date < $1.date })!
                        }
                    }
                    
                    self?.dateLabel.text = self?.newGames.first?.date.convertISODate()
                    
                    if self?.player?.team.abbreviation != self?.newGames.first?.homeTeam.abbreviation {
                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.homeTeam.abbreviation)!)
                    } else {
                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.visitorTeam.abbreviation)!)
                    }
                    
                }
            }
        }
    }
    
    private func loadThisWeeksPTS() {
        PlayerAPIClient.getStatsDated(for: player!.id) { [weak self] (result) in
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
//        print(opposition.description)
        
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
        //        vsTeamLogo.image = UIImage(named: (games.first?.homeTeam.abbreviation)!)
    }
    
    
    
    
}
