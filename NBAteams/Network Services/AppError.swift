//
//  AppError.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

enum AppError: Error, CustomStringConvertible {
    case badURL(String)
    case noResponse
    case networkClientError(Error)
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case badStatusCode(Int)
    case badMimeType(String)
    
    var description: String {
        switch self {
        case .decodingError(let error):
            return "\(error)"
        case .badStatusCode(let code):
            return "Bad status code of \(code) returned from web api"
        case .encodingError(let error):
            return "encoding error: \(error)"
        case .networkClientError(let error):
            return "network error: \(error)"
        case .badURL(let url):
            return "\(url) is a bad url"
        case .noData:
            return "no data returned from web api"
        case .noResponse:
            return "no response returned from web api"
        case .badMimeType(let mimeType):
            return "Verify your mime type found a \(mimeType) mime type"
        }
    }
}
