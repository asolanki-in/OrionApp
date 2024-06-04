//
//  RedditOAuthService.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

actor RedditOAuthService {

	private var refreshTask: Task<Token, Error>?
	let servicePath = "https://www.reddit.com/api/v1/access_token"
	let mePath = "https://oauth.reddit.com/api/v1/me"

	public func getOAuthToken(from code: String) async throws -> Token {
		let task = Task { () throws -> Token in
			let bodyString = "grant_type=authorization_code&code=" + code + "&redirect_uri=" + AppConfig.shared.redirectURI
			let httpBody = bodyString.data(using: .utf8)
			var httpRequest = URLRequest(url: URL(string: servicePath)!)
			httpRequest.httpMethod = "POST"
			httpRequest.setValue(AppConfig.shared.userAgent, forHTTPHeaderField: "User-Agent")
			httpRequest.httpBody = httpBody
			httpRequest.setValue(AppConfig.shared.getBasic, forHTTPHeaderField: "Authorization")

			let (data, response) = try await URLSession.shared.data(for: httpRequest)

//			print(String(data: data, encoding: .utf8))

			guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
				throw NetworkErrors.UnknownReponse("Failed to get token using code. unable to parse response")
			}
			guard let token = try CHelper.decode(data, as: Token.self) else {
				throw DecodingErrors.decodeFailed("Token decoding failed")
			}
			return token
		}
		return try await task.value
	}

	public func getUser(for token: Token) async throws -> User {
		var httpRequest = URLRequest(url: URL(string: mePath)!)
		httpRequest.httpMethod = "GET"
		httpRequest.setValue(AppConfig.shared.userAgent, forHTTPHeaderField: "User-Agent")
		httpRequest.setValue("Bearer \(token.accessToken ?? "")", forHTTPHeaderField: "Authorization")

		let (data, response) = try await URLSession.shared.data(for: httpRequest)
		guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
			throw NetworkErrors.UnknownReponse("\(#function) Response failed")
		}
		guard let user = try CHelper.decode(data, as: User.self) else {
			throw DecodingErrors.decodeFailed("\(#function) User decoding failed")
		}
		return user
	}

	public func refresh(_ token: Token?) async throws -> Token {
		if let refreshTask {
			return try await refreshTask.value
		}

		let task = Task { () throws -> Token in
			defer { refreshTask = nil }

			var httpRequest = URLRequest(url: URL(string: servicePath)!)
			httpRequest.httpMethod = "POST"
			httpRequest.setValue(AppConfig.shared.userAgent, forHTTPHeaderField: "User-Agent")
			httpRequest.setValue(AppConfig.shared.getBasic, forHTTPHeaderField: "Authorization")
			if let refreshToken = token?.refreshToken {
				let bodyString = "grant_type=refresh_token&refresh_token=" + refreshToken
				let httpBody = bodyString.data(using: .utf8)
				httpRequest.httpBody = httpBody
			} else {
				throw OAuthErrors.RefreshTokenMissing
			}

			let (data, response) = try await URLSession.shared.data(for: httpRequest)
			guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
				throw NetworkErrors.UnknownReponse("\(#function) Token Refresh response failed")
			}
			guard let refreshedToken = try CHelper.decode(data, as: Token.self) else {
				throw DecodingErrors.decodeFailed("\(#function) Refreshed Token")
			}
			return refreshedToken
		}
		self.refreshTask = task
		return try await task.value
	}

	public func refreshAnonymousToken() async throws -> Token {
		if let refreshTask {
			return try await refreshTask.value
		}

		let task = Task { () throws -> Token in
			defer { refreshTask = nil }

			var httpRequest = URLRequest(url: URL(string: servicePath)!)
			httpRequest.httpMethod = "POST"
			httpRequest.setValue(AppConfig.shared.userAgent, forHTTPHeaderField: "User-Agent")
			httpRequest.setValue(AppConfig.shared.getBasic, forHTTPHeaderField: "Authorization")
			let bodyString = "grant_type=https://oauth.reddit.com/grants/installed_client&device_id=" + UUID().uuidString
			let httpBody = bodyString.data(using: .utf8)
			httpRequest.httpBody = httpBody

			let (data, response) = try await URLSession.shared.data(for: httpRequest)
			guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
				throw NetworkErrors.UnknownReponse("\(#function) Token response failed for anonymous")
			}
			guard let refreshedToken = try CHelper.decode(data, as: Token.self) else {
				throw DecodingErrors.decodeFailed("\(#function) Refreshed Token for anonymous")
			}
			return refreshedToken
		}
		self.refreshTask = task
		return try await task.value
	}

}
