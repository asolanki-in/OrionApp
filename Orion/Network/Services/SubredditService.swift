//
//  SubredditService.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

struct SubredditService : NetworkService {
	public func get(subreddit: String) async throws -> Subreddit {
		let endpoint = SubredditEndpoint.about(name: subreddit)
		let thing : Thing<Subreddit> = try await self.load(endpoint, allowRetry: true)
		return thing.data
	}

	public func joinSubreddit(name: String, status: Bool) async throws -> AnyCodable {
		let endpoint = SubredditEndpoint.join(name: name, status: status)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getSubRedditModerators(_ name: String, next: String?) async throws -> Thing<ThingData<Moderator>> {
		let endpoint = SubredditEndpoint.moderators(name: name, next: next)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getSubRedditRules(_ name: String) async throws -> Rules {
		let endpoint = SubredditEndpoint.rules(name: name)
		return try await self.load(endpoint, allowRetry: true)
	}

}
