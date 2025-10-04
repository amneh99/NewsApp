//
//  String.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import Foundation

extension String {
    func relativeTimeAgo() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: self) ?? ISO8601DateFormatter().date(from: self) else {
            return nil
        }
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .abbreviated
        
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}
