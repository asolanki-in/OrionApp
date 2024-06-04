//
//  SubredditEndpoint.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

enum SubredditEndpoint {
	case about(name: String)
	case join(name: String, status: Bool)
	case moderators(name: String, next: String?)
	case rules(name: String)
}

extension SubredditEndpoint : Endpoint {
	var path: String {
		switch self {
		case .about(let name):
			return "/\(name)/about.json"
		case .join:
			return "/api/subscribe"
		case .moderators(let name, _):
			return "/r/\(name)/about/moderators.json"
		case .rules(let name):
			return "/r/\(name)/about/rules"
		}
	}

	var httpMethod: HTTPMethod {
		switch self {
		case .join:
			return .post
		default:
			return .get
		}
	}

	var httpBody: Data? {
		switch self {
		case .join(let name, let status):
			return "sr=\(name)&action=\(status ? "sub" : "unsub")".data(using: .utf8)
		default:
			return nil
		}

	}

	var queryParamters: [URLQueryItem]? {
		var params = [URLQueryItem(name: "api_type", value: "json"), URLQueryItem(name: "raw_json", value: "1")]
		switch self {
		case .about, .rules:
			return params
		case .join:
			return params
		case .moderators(_, let next):
			if let next = next, next.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: next))
			}
			params.append(URLQueryItem(name: "limit", value: "30"))
			return params
		}
	}
}
