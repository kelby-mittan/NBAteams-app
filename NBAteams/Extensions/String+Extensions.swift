//
//  String+Extensions.swift
//  NBAteams
//
//  Created by Kelby Mittan on 1/2/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

extension String {
//
////    let onlineDate = "2019-10-25T00:00:00.000Z"
////
////    let isoDateFormatter = ISO8601DateFormatter()
////    isoDateFormatter.formatOptions = [
////        .withFullDate,
////        .withTime,
////        .withDashSeparatorInDate,
////        .withColonSeparatorInTime
////    ]
////
////    let date = isoDateFormatter.date(from: onlineDate)
////
////    let dateFormatter = DateFormatter()
////    dateFormatter.timeZone = TimeZone(identifier: "UTC")
////    dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
////
////    let dateString = dateFormatter.string(from: date!)
////
////    print(date)
////
////    print(dateString)
//
//
//    // returns an ISO8601DateFormatter
    static func getISOFormatter() -> ISO8601DateFormatter {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = .current
        isoDateFormatter.formatOptions = [
//            .withInternetDateTime,
//            .withFullDate,
//            .withFullTime,
//            .withFractionalSeconds, // must have this option
//            .withColonSeparatorInTimeZone,
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]
        return isoDateFormatter
    }

    // creates a timestamp - then creates date and time of the object
    static func getISOTimestamp() -> String { // Date()
//        let isoDateFormatter = getISOFormatter()

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = .current//Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d yyyy"

        let timestamp = dateFormatter.string(from: Date())

//        let timestamp = isoDateFormatter.string(from: Date()) // current date and time
        return timestamp
    }


    func convertISODate() -> String {
        let isoDateFormatter = String.getISOFormatter()
        guard let date = isoDateFormatter.date(from: self) else {
            return self
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy,"

        let dateString = dateFormatter.string(from: date)

        return dateString
    }

    func isoStringToDate() -> Date {
        let isoDateFormatter = String.getISOFormatter()
        guard let date = isoDateFormatter.date(from: self) else {
            return Date()
        }
        return date
    }

}

//extension String {
//
//    // returns an ISO8601DateFormatter
//    static func getISOFormatter() -> ISO8601DateFormatter {
//        let isoDateFormatter = ISO8601DateFormatter()
//        isoDateFormatter.timeZone = .current
//        isoDateFormatter.formatOptions = [
//            .withInternetDateTime,
//            .withFullDate,
//            .withFullTime,
//            .withFractionalSeconds, // must have this option
//            .withColonSeparatorInTimeZone
//        ]
//        return isoDateFormatter
//    }
//
//    // creates a timestamp - then creates date and time of the object
//    static func getISOTimestamp() -> String { // Date()
//        let isoDateFormatter = getISOFormatter()
//        let timestamp = isoDateFormatter.string(from: Date()) // current date and time
//        return timestamp
//    }
//
//
//    func convertISODate() -> String {
//        let isoDateFormatter = String.getISOFormatter()
//        guard let date = isoDateFormatter.date(from: self) else {
//            return self
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM d yyyy, h:mm a"
//
//        let dateString = dateFormatter.string(from: date)
//
//        return dateString
//    }
//
//    func isoStringToDate() -> Date {
//        let isoDateFormatter = String.getISOFormatter()
//        guard let date = isoDateFormatter.date(from: self) else {
//            return Date()
//        }
//        return date
//    }
//
//}
//
