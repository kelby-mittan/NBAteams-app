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
    @IBOutlet var glassesImage: UIImageView!
    @IBOutlet var glassesButton: UIButton!
    
    var player: Player?
    var seasonAvg = Double()
    var weekPtAvg = Double()
    var weeksStats = [Stat]()
    var count = 0.0
    var weekSeason = Double()
    var newGames = [Game]()
    var glassCount = 0
    
    var opposition = 0 {
        didSet {
            getPredictedPoints()
        }
    }
    
    var date = String() {
        didSet {
            getPredictedPoints()
        }
    }
    
    let goodTeams = [2,5,8,12,13,14,16,17,22,23,28,29]
    let trashTeams = [1,5,6,9,10,15,19,20,24,25,26,30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGames()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                    guard var gameDate = self?.newGames.first?.date else {
                        return
                    }
                    
                    gameDate = gameDate.components(separatedBy: "T").first ?? ""
                    self?.date = gameDate
                    
                    self?.dateLabel.text = "\(self?.newGames.first?.date.convertISODate() ?? "") \(self?.newGames.first?.status ?? "")"
                    
                    if self?.player?.team.abbreviation != self?.newGames.first?.homeTeam.abbreviation {
                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.homeTeam.abbreviation)!)
                        
                        self?.opposition = (self?.newGames.first?.homeTeam.id)!
                    } else {
                        self?.vsTeamLogo.image = UIImage(named: (self?.newGames.first?.visitorTeam.abbreviation)!)
                        
                        self?.opposition = (self?.newGames.first?.visitorTeam.id)!
                    }
                    
                    print("Full Date: \(self?.newGames.first?.date ?? "")")
                    
                }
            }
        }
    }
    
    func getDateLastWeek() -> String {
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
        return lastWeekDateString
    }
    
    private func getPredictedPoints() {
        
        guard let playerId = player?.id else {
            showAlert(title: "Error", message: "Could not get player id.")
            return
        }
        
        PlayerAPIClient.getStatsDated(for: playerId, startDate: getDateLastWeek(), endDate: date) { [weak self] (result) in
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
                    
                    guard let week = self?.weekPtAvg, let count = self?.count, let season = self?.seasonAvg, let oppTeam = self?.opposition, let fireTeams = self?.goodTeams, let badTeams = self?.trashTeams else {
                        return
                    }
                    
                    let avg = (week / count)
                    var seasonWeek = (season + avg) / 2
                    self?.weekSeason = seasonWeek
                    
                    switch season {
                    case 30...:
                        if fireTeams.contains(oppTeam) {
                            seasonWeek -= 5
                        } else if badTeams.contains(oppTeam) {
                            seasonWeek += 7
                        }
                    case 25...30:
                        if fireTeams.contains(oppTeam) {
                            seasonWeek -= 3
                        } else if badTeams.contains(oppTeam) {
                            seasonWeek += 5
                        }
                    case 20...25:
                        if fireTeams.contains(oppTeam) {
                            seasonWeek -= 2
                        } else if badTeams.contains(oppTeam) {
                            seasonWeek += 4
                        }
                    case 15...20:
                        if fireTeams.contains(oppTeam) {
                            seasonWeek -= 2
                        } else if badTeams.contains(oppTeam) {
                            seasonWeek += 2
                        }
                    default:
                        self?.trustPointsLabel.text = "Good For...\((String(format: "%.0f", seasonWeek)))"
                    }
                    
                    self?.trustPointsLabel.text = "Good For...\((String(format: "%.0f", seasonWeek)))"
                    
                    print(seasonWeek)
                    print(count)
                    print(avg)
                }
            }
        }
    }
    
    func updateUI() {
        
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
        
    }
    
    @IBAction func glassesButton(_ sender: UIButton) {
        glassCount += 1
        UIView.animate(withDuration: 2.5, animations: {
            if self.glassCount % 2 == 0 {
                self.glassesImage.frame.origin.y -= 155
                self.trustPointsLabel.frame.origin.x += 365
            } else {
                self.glassesImage.frame.origin.y += 155
                self.trustPointsLabel.frame.origin.x -= 365
            }
            
        }, completion: nil)
        
    }
    
    
}
