//
//  SearchData.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import Foundation

typealias SearchThingList = Thing<ThingData<SearchData>>

enum SearchData {
	case subreddit(Subreddit)
	case user(User)
	case unsupported
}

extension SearchData : Decodable, Identifiable {
	var id: UUID { return UUID() }

	private enum CodingKeys: String, CodingKey {
		case kind
		case data
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .kind)
		switch type {
		case "t2":
			let data = try container.decode(User.self, forKey: .data)
			self = .user(data)
		case "t5":
			let data = try container.decode(Subreddit.self, forKey: .data)
			self = .subreddit(data)
		default:
			self = .unsupported
		}
	}

}

