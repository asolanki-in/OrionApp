//
//  UserEndpoints.swift
//  Orion
//
//  Created by Anil Solanki on 02/10/22.
//

import Foundation

enum UserEndpoints {
	case me
	case user(name: String)
	case subreddits(next: String?)
	case customfeed
	case customfeedOther(String)
	case saved(name: String, next: String?)
	case posts(name: String, sort: Sort, next: String?)
	case upvoted(name: String, next: String?)
	case trophies(uesrname: String)
	case allComments(uesrname: String, next: String?)
}

extension UserEndpoints : Endpoint {
	var httpBody: Data? {
		return nil
	}

	var httpMethod: HTTPMethod {
		return .get
	}

	var queryParamters: [URLQueryItem]? {
		var params = [URLQueryItem(name: "api_type", value: "json"),
		URLQueryItem(name: "raw_json", value: "1")]
		switch self {
		case .subreddits(let next):
			if let after = next , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}
			params.append(URLQueryItem(name: "limit", value: "100"))
			return params
		case .saved(_ , let next):
			if let after = next , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}
			params.append(URLQueryItem(name: "sr_detail", value: "1"))
			params.append(URLQueryItem(name: "limit", value: "20"))
			params.append(URLQueryItem(name: "type", value: "links"))
			return params
		case .posts(_, let sort, let next):
			if let after = next , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}
			params.append(URLQueryItem(name: "sort", value: sort.itemValue))
			params.append(URLQueryItem(name: "limit", value: "20"))
			params.append(URLQueryItem(name: "sr_detail", value: "1"))
			params.append(URLQueryItem(name: "always_show_media", value: "1"))
			return params
		case .allComments(_, let next):
			if let after = next , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}
			params.append(URLQueryItem(name: "limit", value: "30"))
			params.append(URLQueryItem(name: "sort", value: "new"))
			return params
		case .upvoted(_, let next):
			if let after = next , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}
			params.append(URLQueryItem(name: "limit", value: "30"))
			params.append(URLQueryItem(name: "sort", value: "new"))
			params.append(URLQueryItem(name: "sr_detail", value: "1"))
			params.append(URLQueryItem(name: "always_show_media", value: "1"))
			return params
		default:
			return params
		}
	}

	var path: String {
		switch self {
		case .me:
			return "/api/v1/me"
		case .user(let name):
			return "/user/\(name)/about.json"
		case .subreddits:
			return "/subreddits/mine/subscriber.json"
		case .customfeed:
			return "/api/multi/mine"
		case .saved(let name, _):
			return "/user/\(name)/saved.json"
		case .posts(let name, _, _):
			return "/user/\(name)/submitted.json"
		case .trophies(let uesrname):
			return "/api/v1/user/\(uesrname)/trophies"
		case .allComments(let uesrname, _):
			return "/user/\(uesrname)/comments.json"
		case .upvoted(let uesrname, _):
			return "/user/\(uesrname)/upvoted.json"
		case .customfeedOther(let username):
			return "/api/multi/user/\(username)"
		}
	}
}
