//
//  Award.swift
//  OrionBeta
//
//  Created by Anil Solanki on 20/08/22.
//

import Foundation

// MARK: - AllAwarding
struct Award: Codable {
	let icons : [AwardIcon]
	let name, description, largeIcon: String

	enum CodingKeys: String, CodingKey {
		case icons = "resized_icons"
		case name, description
		case largeIcon = "icon_url"
	}
}

// MARK: - AwardIcon
struct AwardIcon: Codable, Identifiable {
	let id = UUID()
	let url: String
	let width, height: Int
}
