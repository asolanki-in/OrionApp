//
//  User.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation
import HTMLEntities

struct User : Codable, Identifiable, CustomStringConvertible, Equatable {

	static func == (lhs: User, rhs: User) -> Bool {
		return lhs.name == rhs.name
	}

	var id = UUID()
	let name : String
	let created : TimeInterval?
	let awardeeKarma : Int?
	let awarderKarma : Int?
	let verified : Bool?
	let verifiedEmail : Bool?
	let icon : String?
	let linkKarma : Int?
	let totalKarma : Int?
	let snoovatar : String?
	let commentKarma : Int?
	let subreddit: UserSubreddit?
	let suspended: Bool?

	struct UserSubreddit : Codable {
		let title: String
	}

	enum CodingKeys: String, CodingKey {
		case name, verified , subreddit
		case created = "created_utc"
		case awardeeKarma = "awardee_karma"
		case awarderKarma = "awarder_karma"
		case verifiedEmail = "has_verified_email"
		case icon = "icon_img"
		case linkKarma = "link_karma"
		case totalKarma = "total_karma"
		case snoovatar = "snoovatar_img"
		case commentKarma = "comment_karma"
		case suspended = "is_suspended"
	}

	var isAnonymous : Bool {
		if name == "nIH6CNkoDR4mT9StcUgbmHHXK_Orion_anonymous" {
			return true
		}
		return false
	}

	var active: Bool {
		if let current = UserDefaults.standard.string(forKey: "current_user") {
			if current == self.name {
				return true
			} else {
				return false
			}
		} else  {
			return true
		}
	}

	var nameTitle : String {
		if isAnonymous {
			return "Anonymous"
		}
		return name
	}

	var displayName: String {
		if let title = self.subreddit?.title, title.isEmpty == false {
			return title
		} else {
			return nameTitle
		}
	}

	var profileImage : URL? {
		if let primary = self.snoovatar, primary.isEmpty == false {
			return URL(string: primary.htmlUnescape())
		} else if let secondary = self.icon, secondary.isEmpty == false {
		   return URL(string: secondary.htmlUnescape())
		} else {
			return URL(string: "https://www.redditstatic.com/avatars/avatar_default_01_FF585B.png")
		}
	}

	var profileImageString : String {
		if let primary = self.snoovatar, primary.isEmpty == false {
			return primary.htmlUnescape()
		} else if let secondary = self.icon, secondary.isEmpty == false {
		   return secondary.htmlUnescape()
		} else {
			return "https://www.redditstatic.com/avatars/avatar_default_01_FF585B.png"
		}
	}


	
}

extension User {
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try values.decode(String.self, forKey: .name)
		self.created = try values.decodeIfPresent(TimeInterval.self, forKey: .created)
		self.awardeeKarma = try values.decodeIfPresent(Int.self, forKey: .awardeeKarma)
		self.awarderKarma = try values.decodeIfPresent(Int.self, forKey: .awarderKarma)
		self.verified = try values.decodeIfPresent(Bool.self, forKey: .verified)
		self.verifiedEmail = try values.decodeIfPresent(Bool.self, forKey: .verifiedEmail)
		self.icon = try values.decodeIfPresent(String.self, forKey: .icon)
		self.linkKarma = try values.decodeIfPresent(Int.self, forKey: .linkKarma)
		self.totalKarma = try values.decodeIfPresent(Int.self, forKey: .totalKarma)
		self.snoovatar = try values.decodeIfPresent(String.self, forKey: .snoovatar)
		self.commentKarma = try values.decodeIfPresent(Int.self, forKey: .commentKarma)
		self.subreddit = try values.decodeIfPresent(UserSubreddit.self, forKey: .subreddit)
		self.suspended = try values.decodeIfPresent(Bool.self, forKey: .suspended)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(created, forKey: .created)
		try container.encode(awardeeKarma, forKey: .awardeeKarma)
		try container.encode(awarderKarma, forKey: .awarderKarma)
		try container.encode(verified, forKey: .verified)
		try container.encode(verifiedEmail, forKey: .verifiedEmail)
		try container.encode(icon, forKey: .icon)
		try container.encode(linkKarma, forKey: .linkKarma)
		try container.encode(totalKarma, forKey: .totalKarma)
		try container.encode(snoovatar, forKey: .snoovatar)
		try container.encode(commentKarma, forKey: .commentKarma)
		try container.encode(subreddit, forKey: .subreddit)
		try container.encode(suspended, forKey: .suspended)
	}
}

extension User {

	static private func AnonymousUUID() -> UUID {
		if let uuid = UUID(uuidString: "34DB9E8C-AF30-4096-A700-645D978CD341") {
			return uuid
		}
		return UUID()
	}
	static let anonymous = User(id: AnonymousUUID(),
								name: "34DB9E8C-AF30-4096-A700-645D978CD341",
								created: 0000,
								awardeeKarma: 0,
								awarderKarma: 0,
								verified: true,
								verifiedEmail: true,
								icon: "",
								linkKarma: 0,
								totalKarma: 0,
								snoovatar: "https://i.redd.it/qaowx02uutx51.png",
								commentKarma: 0,
								subreddit: nil,
								suspended: false)
}

extension CustomStringConvertible where Self: Codable {
	var description: String {
		var description = "\n \(type(of: self)) \n"
		let selfMirror = Mirror(reflecting: self)
		for child in selfMirror.children {
			if let propertyName = child.label {
				description += "\(propertyName): \(child.value)\n"
			}
		}
		return description
	}
}

struct UserSearchData : Decodable, Identifiable {
	var id = UUID().uuidString
	let name: String
	let icon_img: String?

	enum CodingKeys: String, CodingKey {
		case name, icon_img
	}
}
