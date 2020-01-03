//
//  TeamScheduleController.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class TeamScheduleController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var games = [Game]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var gamesSections = [[Game]]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var scheduledGames = [Game]()
    
    var teamId: Int?
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGames()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    private func loadGames() {
        GamesAPIClient.getGames(for: teamId!) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let games):
                DispatchQueue.main.async {
                    self?.games = games.sorted { $0.date < $1.date }
                }
            }
        }
        navigationItem.title = team?.abbreviation
    }
    
    private func getGameSections() -> [[Game]] {
        
        GamesAPIClient.getGames(for: teamId!) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let games):
                DispatchQueue.main.async {
                    self?.scheduledGames = games.sorted { $0.date < $1.date }
                }
            }
        }
        var monthTitles = Set<String>()
        
        for game in scheduledGames {
            let month = game.date.convertISODate().components(separatedBy: " ").first ?? ""
            monthTitles.insert(month)
        }
        
        var sectionsArr = Array(repeating: [Game](), count: monthTitles.count)
        var currentIndex = 0
        var currentMonth = scheduledGames.first?.date.convertISODate().components(separatedBy: " ").first ?? ""
        
        for game in scheduledGames {
            let theMonth = game.date.convertISODate().components(separatedBy: " ").first
        
                if theMonth == currentMonth {
                    sectionsArr[currentIndex].append(game)
                } else {
                    currentIndex += 1
                    currentMonth = game.date.convertISODate().components(separatedBy: " ").first ?? ""
                    sectionsArr[currentIndex].append(game)
                }
            }
        return sectionsArr
    }
    
}

extension TeamScheduleController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GameCell else {
            fatalError()
        }
        let game = games[indexPath.row]
        cell.selectedTeamId = teamId
        cell.configureCell(for: game)
        
        return cell
    }
}

extension TeamScheduleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
