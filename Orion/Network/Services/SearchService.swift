//
//  SearchService.swift
//  Orion
//
//  Created by Anil Solanki on 20/11/22.
//

import Foundation

struct SearchService : NetworkService {

	public func searchPosts(query: String, sort: Sort, after: String?) async throws -> ThingList<Post> {
		let endpoint = SearchEndpoint.searchPosts(query, sort, after)
		return try await self.load(endpoint, allowRetry: true)
	}

	public func searchUsers(query: String, sort: Sort, after: String?) async throws -> ThingList<UserSearchData> {
		let endpoint = SearchEndpoint.searchUsers(query, sort, after)
		return try await self.load(endpoint, allowRetry: true)
	}

	public func searchSubreddits(query: String, sort: Sort, after: String?) async throws -> ThingList<Subreddit> {
		let endpoint = SearchEndpoint.searchSubreddits(query, sort, after)
		return try await self.load(endpoint, allowRetry: true)
	}

	public func searchDefaultSubreddits(query: String, after: String?) async throws -> ThingList<Subreddit> {
		let endpoint = SearchEndpoint.searchDefaultSubreddits(query, after)
		return try await self.load(endpoint, allowRetry: true)
	}

	public func autoComplete(query: String) async throws -> SearchThingList {
		let endpoint = SearchEndpoint.autoCompleteSearch(query)
		return try await self.load(endpoint, allowRetry: true)
	}

}
