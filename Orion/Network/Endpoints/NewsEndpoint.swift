//
//  NewsEndpoint.swift
//  Orion
//
//  Created by Anil Solanki on 19/11/22.
//

import Foundation

enum NewsEndpoint {
	case categories
}

extension NewsEndpoint : Endpoint {

	var httpBody: Data? {
		return nil
	}

	var httpMethod: HTTPMethod {
		return .get
	}

	var queryParamters: [URLQueryItem]? {
		return [URLQueryItem(name: "api_type", value: "json"),URLQueryItem(name: "raw_json", value: "1")]
	}

	var path: String {
		switch self {
		case .categories:
			return "/api/multi/user/asolanki26"
		}
	}
}
