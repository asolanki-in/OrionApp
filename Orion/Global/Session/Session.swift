//
//  Session.swift
//  Orion
//
//  Created by Anil Solanki on 04/12/22.
//

import Foundation

final class Session {

	static let shared = Session()
	private init() {}

	var token : Token?
	var username: String = .anonymous
	let auth = RedditOAuth()

	public func updateSession(for username: String) {
		self.username = username
		do {
			self.token = try self.auth.get(tokenFor: username)
		} catch {
			print(error)
		}
	}

	func refreshToken() async throws {
		self.token = try await self.auth.refreshToken(username: self.username, token: self.token)
	}

}
