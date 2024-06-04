//
//  PostListType.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

enum PostListType : Hashable {
	case all
	case popular
	case custom(String)
	case subreddit(String)
	case user(String)
	case upvoted(String)

	var stringValue : String {
		switch self {
		case .all:
			return "/r/all/"
		case .popular:
			return "/r/popular/"
		case .subreddit(let string):
			return "/\(string)/"
		case .custom(let path):
			return path
		case .user(let name):
			return name
		case .upvoted(let name):
			return name
		}
	}

	var displayName : String {
		switch self {
		case .all:
			return "All"
		case .popular:
			return "Popular"
		case .subreddit(let string):
			return string
		case .custom(let path):
			if path.isEmpty {
				return "Home"
			}
			let components = path.split(separator: "/")
			if let last = components.last {
				return last.capitalized
			}
			return path
		case .user(let name):
			return "u/\(name)"
		case .upvoted(let name):
			return name
		}
	}

	func hash(into hasher: inout Hasher) {
		switch self {
		case .all:
			hasher.combine(1)
		case .popular:
			hasher.combine(2)
		case .custom:
			hasher.combine(3)
		case .subreddit:
			hasher.combine(4)
		case .user:
			hasher.combine(5)
		case .upvoted:
			hasher.combine(6)
		}
	}

	static func == (lhs: PostListType, rhs: PostListType) -> Bool {
		lhs.hashValue == rhs.hashValue
	}
}

enum PostMoreAction {
	case joinSubreddit
	case upvote
	case downVote
	case save
	case copyText
	case hide
	case share
}
