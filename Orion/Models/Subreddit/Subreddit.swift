//
//  Subreddit.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation
import SwiftUI
import HTMLEntities

struct Subreddit: Codable, Identifiable, CustomStringConvertible {
	var id = UUID().uuidString
	let name: String
	let communityIcon: String?
	let subredditDescription: String?
	let displayName: String
	let title: String
	let iconImg: String?
	let subscribers: Int?
	let displayNamePrefixed: String
	let createdUTC: TimeInterval?
	let publicDescription: String
	let activeUserCount : Int?
	let subredditType: String
	let headerImage: String?
	let bannerImage: String?
	let bannerColorHex: String?

	let iconDecide: String?

	var subscribed : Bool?
	let nsfw : Bool?

	enum CodingKeys: String, CodingKey {
		case communityIcon = "community_icon"
		case subredditDescription = "description"
		case displayName = "display_name"
		case title, name
		case iconImg = "icon_img"
		case subscribers
		case displayNamePrefixed = "display_name_prefixed"
		case createdUTC = "created_utc"
		case publicDescription = "public_description"
		case activeUserCount = "active_user_count"
		case subredditType = "subreddit_type"
		case headerImage = "banner_background_image"
		case bannerImage = "banner_img"
		case bannerColorHex = "banner_background_color"
		case iconDecide = "header_img"
		case subscribed = "user_is_subscriber"
		case nsfw = "over18"
	}

	var icon : String
	var banner : String

	var markdown: AttributedString? {
		if let mdtext = self.subredditDescription?.htmlUnescape(), mdtext.isEmpty == false {
			do {
				let trimmedString = mdtext.trimmingCharacters(in: .whitespacesAndNewlines)
					.replacingOccurrences(of: "\\n{2,}", with: "\n\n", options: .regularExpression)
				return try AttributedString(markdown: trimmedString, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
			} catch {
				print(error.localizedDescription)
			}
		}
		return nil
	}

	var bannerColor : Color {
		if let hex = bannerColorHex, hex.isEmpty == false {
			return Color(hex: hex.replacingOccurrences(of: "#", with: ""))
		}
		return .accentColor
	}

	var dateString: String {
		if let createdUTC = createdUTC {
			return createdUTC.toString()
		} else {
			return ""
		}
	}

	var username: String {
		return displayNamePrefixed.replacingOccurrences(of: "u/", with: "")
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.communityIcon = try container.decodeIfPresent(String.self, forKey: .communityIcon)
		self.subredditDescription = try container.decodeIfPresent(String.self, forKey: .subredditDescription)
		self.displayName = try container.decode(String.self, forKey: .displayName)
		self.title = try container.decode(String.self, forKey: .title)
		self.name = try container.decode(String.self, forKey: .name)
		self.iconImg = try container.decodeIfPresent(String.self, forKey: .iconImg)
		self.subscribers = try container.decodeIfPresent(Int.self, forKey: .subscribers)
		self.displayNamePrefixed = try container.decode(String.self, forKey: .displayNamePrefixed)
		self.createdUTC = try container.decodeIfPresent(TimeInterval.self, forKey: .createdUTC)
		self.publicDescription = try container.decode(String.self, forKey: .publicDescription)
		self.activeUserCount = try container.decodeIfPresent(Int.self, forKey: .activeUserCount)
		self.subredditType = try container.decode(String.self, forKey: .subredditType)
		self.headerImage = try container.decodeIfPresent(String.self, forKey: .headerImage)
		self.bannerImage = try container.decodeIfPresent(String.self, forKey: .bannerImage)
		self.bannerColorHex = try container.decodeIfPresent(String.self, forKey: .bannerColorHex)
		self.iconDecide = try container.decodeIfPresent(String.self, forKey: .iconDecide)
		self.subscribed = try container.decodeIfPresent(Bool.self, forKey: .subscribed)
		self.nsfw = try container.decodeIfPresent(Bool.self, forKey: .nsfw)

		if let _ = self.iconDecide {
			if let sricon = self.communityIcon, sricon.isEmpty == false {
				self.icon = sricon.htmlUnescape()
			} else if let iconimg = self.iconImg, iconimg.isEmpty == false {
				self.icon = iconimg.htmlUnescape()
			} else {
				self.icon = "https://www.redditstatic.com/avatars/avatar_default_02_A5A4A4.png"
			}
		} else {
			if let iconimg = self.iconImg, iconimg.isEmpty == false {
				self.icon = iconimg.htmlUnescape()
			} else if let sricon = self.communityIcon, sricon.isEmpty == false {
				self.icon = sricon.htmlUnescape()
			} else {
				self.icon = "https://www.redditstatic.com/avatars/avatar_default_02_A5A4A4.png"
			}
		}

		if let primaryBanner = self.headerImage, primaryBanner.isEmpty == false  {
			self.banner = primaryBanner.htmlUnescape()
		} else if let secondaryBanner = self.bannerImage, secondaryBanner.isEmpty == false {
			self.banner = secondaryBanner.htmlUnescape()
		} else {
			self.banner = ""
		}
	}

	var memberCountString : String {
		if let subCount = self.subscribers, subCount > 0 {
			return "\(subCount.displayFormat() ?? "no") members"
		}
		return "no mmembers"
	}
}
