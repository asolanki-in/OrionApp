//
//  UserDataService.swift
//  Orion
//
//  Created by Anil Solanki on 02/10/22.
//

import Foundation

struct UserDataService : NetworkService {
	func getMe() async throws -> User {
		return try await self.load(UserEndpoints.me, allowRetry: true)
	}

	func getUser(name: String) async throws -> Thing<User> {
		let endpoint = UserEndpoints.user(name: name)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getMySubscription(after: String?) async throws -> ThingList<Subreddit> {
		let endpoint = UserEndpoints.subreddits(next: after)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getSavedPosts(username: String, after: String?) async throws -> ThingList<Post> {
		let endpoint = UserEndpoints.saved(name: username, next: after)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getPosts(username: String, after: String?, sort: Sort) async throws -> ThingList<Post> {
		let endpoint = UserEndpoints.posts(name: username, sort: sort, next: after)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getUpvotedPosts(username: String, after: String?) async throws -> ThingList<Post> {
		let endpoint = UserEndpoints.upvoted(name: username, next: after)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getCustomFeed() async throws -> [CustomFeeds] {
		let endpoint = UserEndpoints.customfeed
		return try await self.load(endpoint, allowRetry: true)
	}

	func getCustomFeed(of username: String) async throws -> [CustomFeeds] {
		let endpoint = UserEndpoints.customfeedOther(username)
		return try await self.load(endpoint, allowRetry: true)
	}


	func getTrophies(username: String) async throws -> UserTrophy {
		let endpoint = UserEndpoints.trophies(uesrname: username)
		return try await self.load(endpoint, allowRetry: true)
	}

	/*func getUserComments(username: String, next: String?) async throws -> ThingList<UserComment> {
		let endpoint = UserEndpoints.allComments(uesrname: username, next: next)
		return try await self.load(request, allowRetry: true)
	}*/
}
