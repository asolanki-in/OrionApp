//
//  NetworkService.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

protocol NetworkService {
	func load<T:Decodable>(_ endpoint: Endpoint, allowRetry: Bool) async throws -> T
}

extension NetworkService {

	func load<T:Decodable>(_ endpoint: Endpoint, allowRetry: Bool) async throws -> T {

		let request = createURLRequest(endpoint)
		print(request.url?.absoluteString)
		let (data, response) = try await URLSession.shared.data(for: request)
		guard let response = response as? HTTPURLResponse else {
			throw NetworkErrors.NoResponse
		}

		print(response.statusCode)
		switch response.statusCode {
		case 200...299:
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .secondsSince1970
			//data.printJSON()
			return try decoder.decode(T.self, from: data)
		case 451:
			throw NetworkErrors.Unavailable
		case 401, 403:
			if allowRetry {
				try await Session.shared.refreshToken()
				return try await load(endpoint, allowRetry: false)
			} else {
				throw NetworkErrors.Unauthorized
			}
		default:
			throw NetworkErrors.UnknownReponse("\(response.statusCode)")
		}
	}

	private func createURLRequest(_ endpoint: Endpoint) -> URLRequest {
		var httpRequest = URLRequest(url: endpoint.urlComponents.url!)
		httpRequest.timeoutInterval = 60
		httpRequest.cachePolicy = .reloadIgnoringLocalCacheData
		httpRequest.httpMethod = endpoint.httpMethod.rawValue
		if let token = Session.shared.token?.accessToken {
			httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		httpRequest.setValue(AppConfig.shared.userAgent, forHTTPHeaderField: "User-Agent")
		if let body = endpoint.httpBody { httpRequest.httpBody = body }
		return httpRequest
	}

}

extension Data {
	func printJSON() {
		if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
			print(JSONString)
		}
	}
}
