//
//  String+.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9\\+\\.\\_\\%\\-]{1,256}@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func toFormattedDateString(format: String = "dd/MM/yyyy HH:mm") -> String? {
            let isoDateFormatter = ISO8601DateFormatter()
            isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            guard let date = isoDateFormatter.date(from: self) else { return nil }
            
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = format
            customFormatter.timeZone = TimeZone.current
            
            return customFormatter.string(from: date)
        }
}
