//
//  Moderator.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import Foundation

struct Moderator: Decodable {
	let id: String
	let name : String
	let authorFlairText: String?

	enum CodingKeys: String, CodingKey {
		case name, id
		case authorFlairText = "author_flair_text"
	}
}
