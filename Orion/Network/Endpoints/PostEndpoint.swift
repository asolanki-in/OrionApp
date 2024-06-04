//
//  PostEndpoint.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

enum PostEndpoint {
	case posts(path: String, sort: Sort, after: String?)
	case postSave(id: String, category: String)
	case postUnSave(id: String)
	case postvote(id: String, vote: String)
	case postHide(id: String)
	case comments(id: String, sort: Sort)
	case commentsMore(id: String, linkId: String, children: String, sort: Sort)
	case addComment(id: String, text: String)
	case commentsContinue(linkId: String, commentId: String, sort: Sort)
}

extension PostEndpoint : Endpoint {

	var httpBody: Data? {
		switch self {
		case .postSave(let id, let category):
			return "category=\(category)&id=\(id)".data(using: .utf8)
		case .postUnSave(let id):
			return "id=\(id)".data(using: .utf8)
		case .postvote(let id, let vote):
			return "dir=\(vote)&id=\(id)".data(using: .utf8)
		case .postHide(let id) :
			return "id=\(id)".data(using: .utf8)
		case .commentsMore(let id, let linkId, let children, _):
			return "children=\(children)&id=\(id)&link_id=\(linkId)".data(using: .utf8)
		case .addComment(let id, let text):
			return "thing_id=\(id)&text=\(text)".data(using: .utf8)
		default:
			return nil
		}
	}

	var path: String {
		switch self {
		case .comments(let id, _):
			return "/comments/\(id).json"
		case .commentsMore:
			return "/api/morechildren.json"
		case .addComment:
			return "/api/comment"
		case .commentsContinue(let linkId, let commentId, _):
			return "/comments/\(linkId)/_/\(commentId).json"
		case .postSave:
			return "/api/save"
		case .postUnSave:
			return "/api/unsave"
		case .postvote:
			return "/api/vote"
		case .postHide:
			return "/api/hide"
		case .posts(let path, let sort,_):
			var newPath = path
			if path.isEmpty {
				newPath = "/"
			}
			if let parent = sort.parent {
				return "\(newPath)\(parent.lowercased()).json"
			}

			if newPath.hasSuffix("/") == false {
				newPath = newPath + "/"
			}

			return "\(newPath)\(sort.itemValue).json"
		}
	}

	var httpMethod: HTTPMethod {
		switch self {
		case .postSave, .postUnSave, .postvote, .postHide, .commentsMore, .addComment:
			return .post
		default:
			return .get
		}
	}

	var queryParamters: [URLQueryItem]? {
		var params = [URLQueryItem(name: "api_type", value: "json"), URLQueryItem(name: "raw_json", value: "1")]
		switch self {
		case .postSave, .postUnSave, .postvote, .postHide:
			return nil
		case .comments(_, let sort):
			params.append(URLQueryItem(name: "profile_img", value: "1"))
			params.append(URLQueryItem(name: "limit", value: "100"))
			params.append(URLQueryItem(name: "sort", value: sort.itemValue))
			return params
		case .commentsMore(_, _, _, let sort):
			params.append(URLQueryItem(name: "profile_img", value: "1"))
			params.append(URLQueryItem(name: "limit", value: "100"))
			params.append(URLQueryItem(name: "sort", value: sort.itemValue))
			return params
		case .addComment:
			return params
		case .commentsContinue(_, _, let sort):
			params.append(URLQueryItem(name: "profile_img", value: "1"))
			params.append(URLQueryItem(name: "limit", value: "100"))
			params.append(URLQueryItem(name: "sort", value: sort.itemValue))
			return params
		case .posts(_, let sort,let after):
			params.append(URLQueryItem(name: "sr_detail", value: "1"))
			params.append(URLQueryItem(name: "limit", value: "25"))
			params.append(URLQueryItem(name: "always_show_media", value: "1"))
			if let after = after , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}

			if let _ = sort.parent {
				params.append(URLQueryItem(name: "t", value: sort.itemValue))
			}
			return params
		}
	}
}
