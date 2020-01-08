# NBAteams-app

## Description

Points Predictor

## Code Snippet

```swift
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
                    
                }
            }
        }
    }
```

## ScreenShot of App

![teamsTable1](Assets/teamsTable1.png)


## GIF

![gif](Assets/nba-app.gif)
