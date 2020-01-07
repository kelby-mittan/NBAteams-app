//
//  PlayerSearchController.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class PlayerSearchController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var players = [Player]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchQuery = "" {
        didSet {
            DispatchQueue.main.async {
                self.loadPlayers(for: self.searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        
    }
    
    
    private func loadPlayers(for search: String) {
        PlayerAPIClient.getPlayers(for: search) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let players):
                DispatchQueue.main.async {
                    self?.players = players
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let playerVC = segue.destination as? PlayerDetailController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("could not load")
        }
        
        playerVC.player = players[indexPath.row]
    }
    
    
}

extension PlayerSearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerCell else {
            fatalError()
        }
        let player = players[indexPath.row]
        cell.configureCell(for: player)
        
        return cell
    }
}

extension PlayerSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}

extension PlayerSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {
            return
        }
        searchQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        PlayerAPIClient.getPlayers(for: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let players):
                DispatchQueue.main.async {
                    self?.players = players
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        searchQuery = searchQuery.replacingOccurrences(of: " ", with: "")
        
        PlayerAPIClient.getPlayers(for: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let players):
                DispatchQueue.main.async {
                    self?.players = players
                }
            }
        }
    }
    
}
