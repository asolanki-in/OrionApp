//
//  RedditOAuth.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

final class RedditOAuth {

	var state : String = ""
	let service = RedditOAuthService()
	let store = TokenStore()

	public func refreshToken(user: User, token: Token?) async throws -> Token {
		let token = try await self.refresh(token: token, user: user)
		try self.save(token, username: user.name)
		return token
	}

	public func refreshToken(username: String, token: Token?) async throws -> Token {
		if (username == .anonymous) {
			let token = try await self.service.refreshAnonymousToken()
			try self.save(token, username: username)
			return token
		} else {
			let token = try await self.service.refresh(token)
			try self.save(token, username: username)
			return token
		}
	}

	private func refresh(token: Token?, user: User) async throws -> Token {
		if user.isAnonymous {
			return try await self.service.refreshAnonymousToken()
		} else {
			return try await self.service.refresh(token)
		}
	}
}

extension RedditOAuth {
	public func save(_ token: Token, username: String) throws {
		try store.save(token: token, for: username)
	}

	public func get(tokenFor username: String) throws -> Token {
		return try store.getToken(of: username)
	}

	public func getUser(for token: Token) async throws -> User {
		return try await service.getUser(for: token)
	}

	public func getToken(from code: String) async throws -> Token {
		return try await service.getOAuthToken(from: code)
	}

	public func getCode(from url: URL) async throws -> String {
		return try RedditOAuth.handleRedirect(url, state: self.state)
	}

	public func challengeURL() -> URL? {
		return RedditOAuth.challengeURL(state: self.state,
										clientId: AppConfig.shared.clientID,
										URI: AppConfig.shared.redirectURI)
	}
}

extension RedditOAuth {
	static func challengeURL(state: String, clientId: String, URI: String) -> URL? {
		let scopes = ["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit", "wikiread"]
		let scopesString = scopes.joined(separator: ",")
		var authURLComponent = URLComponents()
		authURLComponent.scheme = "https"
		authURLComponent.host = "www.reddit.com"
		authURLComponent.path = "/api/v1/authorize.compact"
		authURLComponent.queryItems = [
			URLQueryItem(name: "client_id", value: clientId),
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "state", value: state),
			URLQueryItem(name: "redirect_uri", value: URI),
			URLQueryItem(name: "duration", value: "permanent"),
			URLQueryItem(name: "scope", value: scopesString)
		]
		return authURLComponent.url
	}

	static func handleRedirect(_ url: URL, state: String) throws -> String {
		return try self.getCodeFromRedirect(url, state: state)
	}

	static private func getCodeFromRedirect(_ url: URL, state: String) throws -> String {
		if url.scheme == "orionapp" {
			let params = ParametersFrom(url: url)
			if let receivedState = params["state"], state == receivedState {
				if let code = params["code"] {
					return code
				} else {
					throw OAuthErrors.InvalidCodeOrEmpty
				}
			} else {
				throw OAuthErrors.InvalidState
			}
		} else {
			throw OAuthErrors.InvalidScheme
		}
	}
}


struct ParametersFrom {
	let queryItems: [URLQueryItem]
	init(url: URL?) {
		queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? []
	}
	subscript(name: String) -> String? {
		return queryItems.first(where: { $0.name == name })?.value
	}
}
