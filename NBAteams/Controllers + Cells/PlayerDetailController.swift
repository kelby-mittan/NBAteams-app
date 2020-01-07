//
//  PlayerDetailController.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class PlayerDetailController: UIViewController {

    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statPicker: UIPickerView!

    @IBOutlet var statLabel: UILabel! = {
        let label = UILabel()
        return label
    }()
    
    var player: Player?
    
    var stat: Stat?
    
    var selectedRow = Int()
    
    private let stats = ["Games", "Minutes", "FG Made", "FG Attempts", "3's Made", "3's Attempted", "Free Throws Made", "Free Throw Attempts", "Off. Reb", "Def. Reb", "Rebound %", "Assists", "Steals", "Blocks", "Turnovers", "Fouls", "Points", "FG %", "3 PT %", "Free Throw %"]
    
    var statName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        statPicker.dataSource = self
        statPicker.delegate = self
        nameLabel.layer.masksToBounds = true
        nameLabel.layer.cornerRadius = 10
        statLabel.layer.masksToBounds = true
        statLabel.layer.cornerRadius = 10
        statLabel.isHidden = true
        
        
        loadPlayerStats()
        updateUI()
    }
    
//    @objc func handleObject() {
//        let stat = 100.0
//        self.statLabel.text = "\(stat)"
//    }
    
    private func loadPlayerStats() {
        PlayerAPIClient.getPlayerStats(for: player!.id) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let stat):
                DispatchQueue.main.async {
                    self?.stat = stat
                }
            }
        }
        
    }
    
    func updateUI() {
        
        
        nameLabel.text = "\(player?.firstName ?? "") \(player?.lastName ?? "")"
        
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
    
    @IBAction func statButton(_ sender: UIButton) {
        
        statLabel.isHidden = false
        
        switch selectedRow {
        case 0:
            statLabel.text = "Games: \(stat?.gamesPlayed.description ?? "N/A")"
        case 1:
            statLabel.text = "Min: \(stat?.min ?? "N/A")"
        case 2:
            statLabel.text = "FG Made: \(stat?.fgm.description ?? "N/A")"
        case 3:
            statLabel.text = "FG Attempts: \(stat?.fga.description ?? "N/A")"
        case 4:
            statLabel.text = "3's Made: \(stat?.fg3m.description ?? "N/A")"
        case 5:
            statLabel.text = "3's Attempted: \(stat?.fg3a.description ?? "N/A")"
        case 6:
            statLabel.text = "Free Throws Made: \(stat?.ftm.description ?? "N/A")"
        case 7:
            statLabel.text = "Free Throw Attempts: \(stat?.fta.description ?? "N/A")"
        case 8:
            statLabel.text = "Off. Reb: \(stat?.oreb.description ?? "N/A")"
        case 9:
            statLabel.text = "Def. Reb: \(stat?.dreb.description ?? "N/A")"
        case 10:
            statLabel.text = "Rebound %: \(stat?.reb.description ?? "N/A")"
        case 11:
            statLabel.text = "Assists: \(stat?.ast.description ?? "N/A")"
        case 12:
            statLabel.text = "Steals: \(stat?.stl.description ?? "N/A")"
        case 13:
            statLabel.text = "Blocks: \(stat?.blk.description ?? "N/A")"
        case 14:
            statLabel.text = "Turnovers: \(stat?.turnover.description ?? "N/A")"
        case 15:
            statLabel.text = "Fouls: \(stat?.pf.description ?? "N/A")"
        case 16:
            statLabel.text = "Points: \(stat?.pts.description ?? "N/A")"
        case 17:
            let fg = (stat?.fgPct ?? 0) * 100
            statLabel.text = "FG %: \(String(format: "%.2f", fg))%"
        case 18:
            let fg3 = (stat?.fg3Pct ?? 0) * 100
            statLabel.text = "3 PT %: \(String(format: "%.2f", fg3))%"
        case 19:
            let ftPct = (stat?.ftPct ?? 0) * 100
            statLabel.text = "Free Throw %: \(String(format: "%.2f", ftPct))%"
        default:
            statLabel.text = ""
        }
        
        
        
//        statLabel.isHidden = false
//        view.addSubview(statLabel)
//        statLabel.frame = view.frame
//
//        let displayLink = CADisplayLink(target: self, selector: #selector(handleObject))
//        displayLink.add(to: .main, forMode: .default)
    }
    
}

extension PlayerDetailController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stats.count
    }
}

extension PlayerDetailController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stats[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statName = stats[row]
        selectedRow = row
    }
    
}

