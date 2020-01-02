//
//  TeamsViewController.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var teams = [Team]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTeams()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    private func loadTeams() {
        TeamsAPIClient.getTeams { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let teams):
                DispatchQueue.main.async {
                    self?.teams = teams
                }
            }
        }
        
    }
    
    //        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //            guard let teamVC = segue.destination as? TeamScheduleController, let indexPath = tableView.indexPathForSelectedRow else {
    //                fatalError("could not load")
    //            }
    //            teamVC.team = teams[indexPath.row]
    //        }
    
}

extension TeamsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamCell else {
            fatalError()
        }
        let team = teams[indexPath.row]
        cell.configureCell(for: team)
        
        return cell
    }
}

extension TeamsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
}
