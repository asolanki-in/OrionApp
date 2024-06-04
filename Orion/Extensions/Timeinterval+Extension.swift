//
//  Timeinterval+Extension.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

extension TimeInterval {
	func toString() -> String {
		if self != 0 {
			let date = Date(timeIntervalSince1970: self)
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			return dateFormatter.string(from: date)
		}
		return ""
	}

	func toDate() -> Date {
		return Date(timeIntervalSince1970: self)
	}

	func timeAgoDisplay() -> String {
		let date = self.toDate()
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .short
		return formatter.localizedString(for: date, relativeTo: Date())
	}
}

extension Date {
	func timeAgoDisplay() -> String {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full
		return formatter.localizedString(for: self, relativeTo: Date())
	}
}
