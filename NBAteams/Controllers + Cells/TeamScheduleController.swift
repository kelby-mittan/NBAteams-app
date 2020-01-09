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
            loadGames()
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
    
    var gameSchedule = [Game]()
    
    //    var gameArr = [Game]() {
    //        didSet {
    //            loadGames()
    //            getGameSections()
    //        }
    //    }
    //
    //    var sections = [[Game]]() {
    //        didSet {
    //            loadGames()
    //            getGameSections()
    //        }
    //    }
    
    var teamId: Int?
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGames()
        getGameSections()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = team?.abbreviation
        
        
    }
    
    //    func loadSections() {
    //        gamesSections = getGameSections()
    //    }
    
    
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
                    //                    self?.gameArr = games.sorted { $0.date < $1.date }
                    self?.getGameSections()
                    for game in games {
                        self?.gameSchedule.append(game)
                    }
                }
            }
        }
        //        dump(gameArr)
        //        if gameArr.count != 0 {
        //            gameArr = games
        //            dump(gameArr)
        //        }
        //        dump(gameSchedule)
        navigationItem.title = team?.abbreviation
    }
    
    private func getGameSections() {
        //        var schGames = [Game]()
        //                dump(gameArr)
        //        GamesAPIClient.getGames(for: teamId!) { [weak self] (result) in
        //            switch result {
        //            case .failure(let appError):
        //                DispatchQueue.main.async {
        //                    self?.showAlert(title: "Error", message: "\(appError)")
        //                }
        //            case .success(let games):
        //                DispatchQueue.main.async {
        //                    //                    schGames = games.sorted { $0.date < $1.date }
        //                    self?.games = games.sorted { $0.date < $1.date }
        //
        //                }
        //            }
        //        }
        
        print("keeps")
        print("going")
        //        dump(gameSchedule)
        var monthTitles = Set<String>()
        
        if games.count != 0 {
            for game in games {
                let month = game.date.convertISODate().components(separatedBy: " ").first ?? ""
                monthTitles.insert(month)
            }
            
            var sectionsArr = Array(repeating: [Game](), count: monthTitles.count)
            var currentIndex = 0
            var currentMonth = games.first?.date.convertISODate().components(separatedBy: " ").first ?? ""
            
            for game in games {
                let theMonth = game.date.convertISODate().components(separatedBy: " ").first
                
                if theMonth == currentMonth {
                    sectionsArr[currentIndex].append(game)
                } else {
                    currentIndex += 1
                    currentMonth = game.date.convertISODate().components(separatedBy: " ").first ?? ""
                    sectionsArr[currentIndex].append(game)
                }
            }
            //             dump(monthTitles)
            //            dump(sectionsArr)
            gamesSections = sectionsArr
            
        }
        //            dump(gamesSections)
    }
    
}

extension TeamScheduleController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return games.count
        return gamesSections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GameCell else {
            fatalError()
        }
        let game = gamesSections[indexPath.section][indexPath.row]
        //        let game = games[indexPath.row]
        cell.selectedTeamId = teamId
        cell.configureCell(for: game)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gamesSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gamesSections[section].first?.date.convertISODate().components(separatedBy: " ").first
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.contentView.backgroundColor = .black
        header.backgroundView?.backgroundColor = .black
        header.textLabel?.textColor = .white
        
        if let textlabel = header.textLabel {
            textlabel.font = textlabel.font.withSize(26)
        }
    }
    
}

extension TeamScheduleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
