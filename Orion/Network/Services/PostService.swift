//
//  PostService.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

struct PostService : NetworkService {
	public func getPosts(_ type: PostListType, sort: Sort, after: String?) async throws -> ThingList<Post> {
		switch type {
		case .user(let name):
			let endpoint = UserEndpoints.posts(name: name, sort: sort, next: after)
			return try await self.load(endpoint, allowRetry: true)
		default:
			let endpoint = PostEndpoint.posts(path: type.stringValue,sort: sort, after: after)
			return try await self.load(endpoint, allowRetry: true)
		}
	}

	public func savePost(id: String, category: String) async throws -> AnyCodable {
		let endpoint = PostEndpoint.postSave(id: id, category: category)
		return try await self.load(endpoint, allowRetry: true)
	}

	public func unsavePost(id: String) async throws -> AnyCodable {
		let endpoint = PostEndpoint.postUnSave(id: id)
		return try await self.load(endpoint, allowRetry: true)
	}

	public func vote(id: String, vote: String) async throws -> AnyCodable {
		let endpoint = PostEndpoint.postvote(id: id, vote: vote)
		return try await self.load(endpoint, allowRetry: true)
	}

	public func hidePost(id: String) async throws -> AnyCodable {
		let endpoint = PostEndpoint.postHide(id: id)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getComments(id: String, sort: Sort) async throws -> [ThingList<Comment>] {
		let endpoint = PostEndpoint.comments(id: id, sort: sort)
		return try await self.load(endpoint, allowRetry: true)
	}

	func getMoreComments(id: String, linkId: String, children: String, sort: Sort) async throws -> MoreComments {
		let endpoint = PostEndpoint.commentsMore(id: id, linkId: linkId, children: children, sort: sort)
		return try await self.load(endpoint, allowRetry: true)
	}

	func addComment(id: String, text: String) async throws -> CommentJSON {
		let endpoint = PostEndpoint.addComment(id: id, text: text)
		return try await self.load(endpoint, allowRetry: true)
	}

	func fetchCommentsContinue(linkId: String, commentId: String, sort: Sort) async throws -> [ThingList<Comment>] {
		let endpoint = PostEndpoint.commentsContinue(linkId: linkId, commentId: commentId, sort: sort)
		return try await self.load(endpoint, allowRetry: true)
	}

}
