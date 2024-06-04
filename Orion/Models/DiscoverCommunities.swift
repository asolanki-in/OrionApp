//
//  DiscoverCommunities.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import Foundation

public enum DiscoverCommunities : String {
	case art = "Art"
	case crypto = "Crypto"
	case finance = "Finance & Business"
	case food = "Food"
	case funny = "Funny"
	case gaming = "Gaming"
	case health = "Health"
	case memes = "Memes"
	case music = "Music"
	case photography = "Photography"
	case pics = "Pics"
	case science = "Science"
	case sports = "Sports"
	case tech = "Technology"
	case travel = "Travel"
	case video = "Videos"

	static let categories = [art, crypto, finance, food, funny, gaming, health, memes, music, photography, pics, science, sports, tech, travel, video]

	public var stringValue: String {
		switch self {
		case .art:
			return "art"
		case .crypto:
			return "crypto"
		case .finance:
			return "finance"
		case .food:
			return "food"
		case .funny:
			return "funny"
		case .gaming:
			return "gaming"
		case .health:
			return "health"
		case .memes:
			return "memes"
		case .music:
			return "music"
		case .photography:
			return "photography"
		case .pics:
			return "pics"
		case .science:
			return "science"
		case .sports:
			return "sports"
		case .tech:
			return "tech"
		case .travel:
			return "travel"
		case .video:
			return "video"
		}
	}

	public var icon: String {
		switch self {
		case .art:
			return "art"
		case .crypto:
			return "crypto"
		case .finance:
			return "finance"
		case .food:
			return "food"
		case .funny:
			return "funny"
		case .gaming:
			return "gaming"
		case .health:
			return "health"
		case .memes:
			return "meme"
		case .music:
			return "music"
		case .photography:
			return "photography"
		case .pics:
			return "pics"
		case .science:
			return "science"
		case .sports:
			return "sports"
		case .tech:
			return "technology"
		case .travel:
			return "travel"
		case .video:
			return "videos"
		}
	}
}
