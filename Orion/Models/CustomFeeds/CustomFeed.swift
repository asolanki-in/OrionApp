//
//  CustomFeed.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import Foundation

struct CustomFeeds: Decodable {
	let data: CustomFeed
}

struct CustomFeed: Decodable, Identifiable {

	var id = UUID().uuidString
	let name: String
	let displayName: String
	let descriptionHtml: String
	let iconString: String
	let subRedditsNames: [[String: String]]
	let createdUTC: Date
	let visibility: String
	let descriptionMD: String
	let path: String
	var selected = false

	enum CodingKeys: String, CodingKey {
		case name, visibility, path
		case displayName = "display_name"
		case descriptionHtml = "description_html"
		case iconString = "icon_url"
		case subRedditsNames = "subreddits"
		case createdUTC = "created_utc"
		case descriptionMD = "description_md"
	}

	var srnamesByComma : String? {
		var arr = [String]()
		for sr in self.subRedditsNames {
			if let srname = sr["name"] {
				arr.append(srname)
			}
		}
		return (arr.map{$0}).joined(separator: ", ")
	}

	var pathBy : String {
		var arr = [String]()
		for sr in self.subRedditsNames {
			if let srname = sr["name"] {
				arr.append(srname)
			}
		}
		return (arr.map{$0}).joined(separator: "+")
	}

	var pathArray : [String]? {
		var arr = [String]()
		for sr in self.subRedditsNames {
			if let srname = sr["name"] {
				arr.append(srname)
			}
		}
		return arr
	}
}
