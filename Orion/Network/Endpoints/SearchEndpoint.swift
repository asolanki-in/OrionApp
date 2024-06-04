//
//  SearchEndpoint.swift
//  Orion
//
//  Created by Anil Solanki on 20/11/22.
//

import Foundation

enum SearchEndpoint {
	case searchPosts(String, Sort, String?)
	case searchUsers(String, Sort, String?)
	case searchSubreddits(String, Sort, String?)
	case searchDefaultSubreddits(String, String?)
	case autoCompleteSearch(String)
}

extension SearchEndpoint : Endpoint {

	var httpBody: Data? {
		return nil
	}

	var httpMethod: HTTPMethod {
		return .get
	}

	var queryParamters: [URLQueryItem]? {
		var params = [URLQueryItem(name: "api_type", value: "json"), URLQueryItem(name: "raw_json", value: "1")]
		switch self {
		case .searchPosts(let query, let sort, let after):
			let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
			params.append(URLQueryItem(name: "q", value: escapedString))
			params.append(URLQueryItem(name: "type", value: "link"))
			params.append(URLQueryItem(name: "sr_detail", value: "1"))
			if let after = after , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}

			if let _ = sort.parent {
				params.append(URLQueryItem(name: "sort", value: sort.parent?.lowercased()))
				params.append(URLQueryItem(name: "t", value: sort.itemValue))
			} else {
				params.append(URLQueryItem(name: "sort", value: sort.itemValue))
			}

		case .searchUsers(let query, let sort, let after):
			let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
			params.append(URLQueryItem(name: "q", value: escapedString))
			params.append(URLQueryItem(name: "type", value: "user"))
			if let after = after , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}

			if let _ = sort.parent {
				params.append(URLQueryItem(name: "sort", value: sort.parent?.lowercased()))
				params.append(URLQueryItem(name: "t", value: sort.itemValue))
			} else {
				params.append(URLQueryItem(name: "sort", value: sort.itemValue))
			}
		case .searchSubreddits(let query, let sort, let after):
			let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
			params.append(URLQueryItem(name: "q", value: escapedString))
			params.append(URLQueryItem(name: "type", value: "sr"))
			if let after = after , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}

			if let _ = sort.parent {
				params.append(URLQueryItem(name: "sort", value: sort.parent?.lowercased()))
				params.append(URLQueryItem(name: "t", value: sort.itemValue))
			} else {
				params.append(URLQueryItem(name: "sort", value: sort.itemValue))
			}
		case .autoCompleteSearch(let query):
			let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
			params.append(URLQueryItem(name: "include_profiles", value: "1"))
			params.append(URLQueryItem(name: "limit", value: "6"))
			params.append(URLQueryItem(name: "query", value: escapedString))
		case .searchDefaultSubreddits(let query, let after):
			let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
			params.append(URLQueryItem(name: "q", value: escapedString))
			params.append(URLQueryItem(name: "type", value: "sr"))
			if let after = after , after.isEmpty == false {
				params.append(URLQueryItem(name: "after", value: after))
			}
			params.append(URLQueryItem(name: "sort", value: "top"))
		}

		return params
	}

	var path: String {
		switch self {
		case .searchUsers, .searchSubreddits, .searchPosts:
			return "/search.json"
		case .searchDefaultSubreddits(let query, _):
			return "/subreddits/\(query).json"
		case .autoCompleteSearch:
			return "/api/subreddit_autocomplete_v2.json"
		}
	}
}
