//
//  Comment.swift
//  Orion
//
//  Created by Anil Solanki on 25/12/22.
//

import Foundation

struct MoreComments: Decodable {

	let json: MoreData

	struct MoreData: Decodable {
		let data: ThingClass
	}

	struct ThingClass : Decodable {
		let things: [Thing<Comment>]
	}
}

struct Comment: Decodable, Identifiable {
	let id: String
	let author: String?
	let createdUtc: TimeInterval?
	let score: Int?
	let body: String?
	var replies : ThingList<Comment>?
	let count : Int?
	let parentId : String?
	let children: [String]?
	let profileImage: String?
	let name: String?
	let linkId: String?
	var upvoted: Bool?

	enum CodingKeys: String, CodingKey {
		case id, author, score, body
		case createdUtc = "created_utc"
		case parentId = "parent_id"
		case replies, count, children
		case profileImage = "profile_img"
		case linkId = "link_id"
		case name
		case upvoted = "likes"
	}

	mutating func add(comments: [Thing<Comment>]) {
		if let _ = replies {
			self.replies?.data.children.append(contentsOf: comments)
		} else {
			self.replies = ThingList(kind: "", data: ThingData(after: nil, children: comments))
		}
	}

	mutating func updateUpvote(to: Bool?) {
		self.upvoted = to
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(String.self, forKey: .id)
		author = try? values.decode(String.self, forKey: .author)
		score = try? values.decode(Int.self, forKey: .score)
		body = try? values.decode(String.self, forKey: .body)
		count = try? values.decode(Int.self, forKey: .count)
		linkId = try? values.decode(String.self, forKey: .linkId)
		children = try? values.decode([String].self, forKey: .children)
		name = try? values.decode(String.self, forKey: .name)
		parentId = try? values.decode(String.self, forKey: .parentId)
		createdUtc = try? values.decode(TimeInterval.self, forKey: .createdUtc)
		profileImage = try? values.decode(String.self, forKey: .profileImage)
		upvoted = try? values.decode(Bool.self, forKey: .upvoted)

		if let replies = try? values.decode(ThingList<Comment>.self, forKey: .replies) {
			self.replies = replies
		} else {
			replies = nil
		}
	}


	var childrenString: String {
		if let child = self.children {
			return (child.map{String($0)}).joined(separator: ",")
		}
		return ""
	}

	var repliesComments: [Comment] {
		if let replies = replies {
			return replies.data.children.map { $0.data }
		}
		return []
	}

	var isUpvoted : Bool {
		if let upvoted = upvoted {
			return upvoted
		}
		return false
	}

	var markdown: AttributedString? {
		if let mdtext = self.body?.htmlUnescape(), mdtext.isEmpty == false {
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
}


enum RepliesError: Error {
	case invalidData
}

extension Thing where T == ThingData<Thing<Comment>> {
	var comments: [Comment]? {
		data.children.map { $0.data }
	}
}

struct CommentJSON : Decodable {
	let json: JSONData

	struct JSONData: Decodable {
		let data: CommentThing
	}

	struct CommentThing: Decodable {
		let things: [Thing<Comment>]
	}
}
