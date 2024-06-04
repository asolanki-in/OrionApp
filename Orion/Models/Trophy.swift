//
//  Trophy.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import Foundation

struct Trophy: Decodable, Identifiable {

	let id = UUID()

	let icon70: String
	let grantedAt: TimeInterval?
	let icon40: String
	let name: String

	enum CodingKeys: String, CodingKey {
		case icon70 = "icon_70"
		case grantedAt = "granted_at"
		case icon40 = "icon_40"
		case name
	}

	var dateString : String {
		return grantedAt?.timeAgoDisplay() ?? ""
	}
}

struct UserTrophy: Decodable {
	let kind: String
	let data: UserTrophyData
}

struct UserTrophyData: Decodable {
	let trophies: [Thing<Trophy>]
}
