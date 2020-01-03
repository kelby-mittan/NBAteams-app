//
//  GamesAPIClient.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct GamesAPIClient {
    
    static func getGames(for teamId: Int, completion: @escaping (Result<[Game],AppError>) -> ()) {
        
        let gameEndpointString = "https://www.balldontlie.io/api/v1/games?seasons[]=2019&team_ids[]=\(teamId.description)&per_page=82"
        
        guard let url = URL(string: gameEndpointString) else {
            completion(.failure(.badURL(gameEndpointString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let gameData = try JSONDecoder().decode(GameData.self, from: data)
                    let games = gameData.data
                    completion(.success(games))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    
}


//static func getStockSections() -> [[AppleStockData]] {
//    let stocks = getStocks()
//    var monthTitles = Set<String>()
//
//    for stock in stocks {
//        var label = stock.label
//        var monthYear = label.components(separatedBy: " ")
//        monthYear.remove(at: 1)
//        label = monthYear.joined()
//        monthTitles.insert(label)
//    }
//
//    var sectionsArr = Array(repeating: [AppleStockData](), count: monthTitles.count)
//    var currentIndex = 0
//    var currentMonth = stocks.first?.label.components(separatedBy: " ").first ?? ""
//    for stock in stocks {
//        let month = stock.label.components(separatedBy: " ").first ?? ""
//
//        if month == currentMonth {
//            sectionsArr[currentIndex].append(stock)
//        } else {
//            currentIndex += 1
//            currentMonth = stock.label.components(separatedBy: " ").first ?? ""
//            sectionsArr[currentIndex].append(stock)
//        }
//    }
//    return sectionsArr
//}
