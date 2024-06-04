//
//  Endpoint.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

protocol Endpoint {
	var host: String { get }
	var path: String { get }
	var httpMethod: HTTPMethod { get }
	var httpBody: Data? { get }
	var queryParamters: [URLQueryItem]? { get }
}

extension Endpoint {
	var host: String {
		return "https://oauth.reddit.com"
	}

	var urlComponents: URLComponents {
		guard var components = URLComponents(string: host) else {
			preconditionFailure("Failed to create URLComponent")
		}
		components.path = path
		components.queryItems = queryParamters
		return components
	}
}

enum HTTPMethod: String {
  case delete = "DELETE"
  case get = "GET"
  case patch = "PATCH"
  case post = "POST"
  case put = "PUT"
}
