//
//  PostViewModel.swift
//  Orion
//
//  Created by Anil Solanki on 02/10/22.
//

import Foundation
import UIKit.UIPasteboard
import UniformTypeIdentifiers
import SwiftUI

extension PostViewModel : Hashable {
	static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
		return lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		return hasher.combine(id)
	}
}

class PostViewModel : ObservableObject, Identifiable {

	var id = UUID().uuidString
	var post: Post
	let service = PostService()
	let listType: PostListType

	var viewAppear = true
	@Published var upvoted: Bool = false
	@Published var downvoted: Bool = false
	@Published var bookmark: Bool = false
	@Published var actionInProgress : Bool = false
	@Published var isCommentLoading: Bool = false
	@Published var addCommentInProgress: Bool = false
	@Published var nodeComments = [CommentNode]()
	@Published var voteInProgress : Bool = false

	@Published var filterItem = Sort(title: "Best", children: nil, icon: "hand.thumbsup", parent: nil, itemValue: "best")


	init(post: Post, listType: PostListType) {
		self.post = post
		self.listType = listType
		self.loadInitialStatus()
	}

	private func loadInitialStatus() {
		if let status = post.likes {
			if status == true {
				self.upvoted = true
				self.downvoted = false
			} else {
				self.upvoted = false
				self.downvoted = true
			}
		} else {
			self.upvoted = false
			self.downvoted = false
		}
		self.bookmark = post.saved
	}

	func fetchComments() {
	  if self.isCommentLoading { return }
	  self.isCommentLoading = true
	  self.getComments(id: post.idString, sort: filterItem)
	}
	
}

extension PostViewModel {
	public func user(type: PostMoreAction) {
		switch type {
		case .joinSubreddit:
			print("")
		case .upvote:
			self.upvote()
		case .downVote:
			self.downvote()
		case .save:
			self.saveUnSavePost()
		case .copyText:
			UIPasteboard.general.setValue(post.title, forPasteboardType: UTType.plainText.identifier)
		case .hide:
			print("")
		case .share:
			print("")
		}
	}

	func upvote() {
		if self.upvoted {
			self.vote(dir: 0, id: post.name)
		} else {
			self.vote(dir: 1, id: post.name)
		}
	}

	func downvote() {
		if self.upvoted {
			self.vote(dir: -1, id: post.name)
		} else {
			self.vote(dir: 0, id: post.name)
		}
	}

	func vote(dir: Int, id: String) {
		self.actionInProgress = true
		Task.detached(priority: .userInitiated) {
			do {
				let thing = try await self.service.vote(id: id, vote: "\(dir)")
				await self.voteCompleted(thing: thing, error: nil, vote: dir)
			} catch {
				await self.voteCompleted(thing: nil, error: error, vote: dir)
			}
		}
	}

	@MainActor private func voteCompleted(thing: AnyCodable?, error: Error?, vote: Int) {
		if let error = error {
			print(error.localizedDescription)
		} else {
			if let thingCodable = thing, thingCodable.error == nil {
				switch vote {
				case 0:
					post.likes = nil
					self.upvoted = false
					self.downvoted = false
				case 1:
					post.likes = true
					self.upvoted = true
					self.downvoted = false
				case -1:
					post.likes = false
					self.upvoted = false
					self.downvoted = true
				default:
					post.likes = nil
					self.upvoted = false
					self.downvoted = false
				}
			}
		}
		self.actionInProgress = false
	}

	func saveUnSavePost() {
		if self.bookmark == true {
			self.unsavePost(id: post.name)
		} else {
			self.savePost(id: post.name, cat: "orion")
		}
	}

	@MainActor private func saveCompleted(thing: AnyCodable?, error: Error?) {
		if let error = error {
			print(error.localizedDescription)
		} else {
			if let thingCodable = thing, thingCodable.error == nil {
				self.bookmark = true
			}
		}
		self.actionInProgress = false
	}

	@MainActor private func unsaveCompleted(thing: AnyCodable?, error: Error?) {
		if let error = error {
			print(error.localizedDescription)
		} else {
			if let thingCodable = thing, thingCodable.error == nil {
				self.bookmark = false
			}
		}
		self.actionInProgress = false
	}

	func savePost(id: String, cat: String) {
		self.actionInProgress = true
		Task.detached(priority: .userInitiated) { [weak self] in
			do {
				let thing = try await self?.service.savePost(id: id, category: cat)
				await self?.saveCompleted(thing: thing, error: nil)
			} catch {
				await self?.saveCompleted(thing: nil, error: error)
			}
		}
	}

	func unsavePost(id: String) {
		self.actionInProgress = true
		Task.detached(priority: .userInitiated) { [weak self] in
			do {
				let thing = try await self?.service.unsavePost(id: id)
				await self?.unsaveCompleted(thing: thing, error: nil)
			} catch {
				await self?.unsaveCompleted(thing: nil, error: error)
			}
		}
	}
}

extension PostViewModel {
	func fetchComments(filterItem: Sort) {
		if self.isCommentLoading { return }
		self.isCommentLoading = true
		self.getComments(id: post.idString, sort: filterItem)
	}

	func getComments(id: String, sort: Sort) {
		Task.detached(priority: .background) { [weak self] in
			do {
				let thing = try await self?.service.getComments(id: id, sort: sort)
				if let last = thing?.last {
					var comments = [CommentNode]()
					for item in last.data.children {
						let childNode = CommentNode(item.data, 0, nil)
						comments.append(childNode)
						if let more = self?.flatMapNodeMore(comment: item.data, indent: 1, parent: childNode) {
							comments.append(contentsOf: more)
						}
					}
					await self?.completedSuccess(more: comments)
				} else {
					await self?.failed(error: NetworkErrors.NoResponse)
				}
			} catch {
				await self?.failed(error: error)
			}
		}
	}

	@MainActor private func failed(error: Error) {
		print(error.localizedDescription)
		self.isCommentLoading = false
	}

	func moreReplies(aNode: CommentNode, linkId: String) async throws -> [CommentNode] {
		let thing = try await self.service.getMoreComments(id: aNode.data.id,
														   linkId: linkId,
														   children: aNode.data.childrenString,
														   sort: self.filterItem)
		let things = thing.json.data.things
		let rootComments = self.convertJsonToTree(json: things, parentId: aNode.data.parentId ?? "")
		var nodes = [Thing<Comment>]()
		for rootComment in rootComments {
			nodes.append(self.adjustChildren(json: things, rootParent: rootComment))
		}

		var comments = [CommentNode]()
		for item in nodes {
			let childNode = CommentNode(item.data, aNode.indent, aNode.parent)
			comments.append(childNode)
			if let more = self.flatMapNodeMore(comment: item.data, indent: childNode.indent + 1, parent: childNode) {
				comments.append(contentsOf: more)
			}
		}

		return comments
	}

	@MainActor private func completedSuccess(more: [CommentNode]) {
		nodeComments = more
		self.isCommentLoading = false
	}

	@MainActor func completed(more: [CommentNode]) {
		nodeComments.removeLast()
		withAnimation {
			nodeComments.append(contentsOf: more)
		}
	}

	@MainActor func completedReplies(more: [CommentNode], startIndex: Int) {
		nodeComments.remove(at: startIndex)
		withAnimation {
			nodeComments.insert(contentsOf: more, at: startIndex)
		}
	}

	func flatMapNodeMore(comment: Comment, indent : Int, parent: CommentNode?) -> [CommentNode]? {
		if let children = comment.replies?.data.children {
			var flatMap = [CommentNode]()
			for child in children {
				let childNode = CommentNode(child.data, indent, parent)
				flatMap.append(childNode)
				if let more = flatMapNodeMore(comment: child.data, indent: indent + 1, parent: childNode) {
					flatMap.append(contentsOf: more)
				}
			}
			return flatMap
		}
		return nil
	}

	func convertJsonToTree(json: [Thing<Comment>], parentId: String) -> [Thing<Comment>] {
		var rootComments = [Thing<Comment>]()
		for item in json {
			if item.data.parentId == parentId {
				rootComments.append(item)
			}
		}
		return rootComments
	}

	func adjustChildren(json: [Thing<Comment>], rootParent: Thing<Comment>) -> Thing<Comment> {
		var parent = rootParent
		for item in json {
			if item.data.parentId == parent.data.name {
				let child = adjustChildren(json: json, rootParent: item)
				parent.data.add(comments: [child])
			}
		}
		return parent
	}

	func getIndex(id: String) -> Int? {
		return self.nodeComments.firstIndex(where: { $0.data.id == id })
	}

	func continueCommentsTapped(linkId: String, commentId: String) {
		self.fetchContinueComments(linkId: linkId, commentId: commentId, sort: filterItem)
	}

	func fetchContinueComments(linkId: String, commentId: String, sort: Sort) {
		Task.detached(priority: .background) { [weak self] in
			do {
				let thing = try await self?.service.fetchCommentsContinue(linkId: linkId, commentId: commentId, sort: sort)
			} catch {
				print("\(error)")
			}
		}
	}

}

extension PostViewModel {

	func upvoteOnComment(vote: Int, fullname: String) async -> Bool {
		do {
			let thing = try await self.service.vote(id: fullname, vote: "\(vote)")
			if thing.error == nil {
				return true
			} else {
				return false
			}
		} catch {
			print(error.localizedDescription)
			return false
		}
	}


	func upvoteComment(status: Bool?, id: String) {
		let vote: Int
		if let status = status {
			if status == true {
				vote = 0
			} else {
				vote = 1
			}
		} else {
			vote = 1
		}
		self.voteComment(dir: vote, id: id)
	}

	func downvoteComment(status: Bool?, id: String) {
		let vote: Int
		if let status = status {
			if status == true {
				vote = -1
			} else {
				vote = 0
			}
		} else {
			vote = -1
		}
		self.voteComment(dir: vote, id: id)
	}

	func voteComment(dir: Int, id: String) {
		Task.detached(priority: .background) { [weak self] in
			do {
				let thing = try await self?.service.vote(id: id, vote: "\(dir)")
				await self?.voteCommentCompleted(thing: thing, error: nil, vote: dir)
			} catch {
				await self?.voteCommentCompleted(thing: nil, error: error, vote: dir)
			}
		}
	}

	@MainActor private func voteCommentCompleted(thing: AnyCodable?, error: Error?, vote: Int) {
		if let error = error {
			print(error.localizedDescription)
		} else {
			if let thingCodable = thing, thingCodable.error == nil {
				switch vote {
				case 0:
					self.post.likes = nil
				case 1:
					self.post.likes = true
				case -1:
					self.post.likes = false
				default:
					self.post.likes = nil
				}
			}
		}
		self.voteInProgress = false
	}

	func addComment(text: String, node: CommentNode?) {
		Task.detached(priority: .background) { [weak self] in
			do {
				var thingId: String = self?.post.name ?? ""
				if let nodeId = node?.data.id {
					thingId = "t1_\(nodeId)"
				}
				let thing = try await self?.service.addComment(id: thingId, text: text)
				if let things = thing?.json.data.things, things.count > 0 {
					await self?.commentAddCompleted(thing: things, error: nil, node: node)
				} else {
					await self?.commentAddCompleted(thing: nil, error: nil, node: node)
				}
			} catch {
				await self?.commentAddCompleted(thing: nil, error: error, node: node)
			}
		}
	}

	@MainActor private func commentAddCompleted(thing: [Thing<Comment>]?, error: Error?, node: CommentNode?) {
		if let error = error {
			print(error.localizedDescription)
		} else if let thing = thing, let commentThing = thing.first {
			if let node = node {
				if let index = self.getIndex(id: node.data.id) {
					let node = CommentNode(commentThing.data, node.indent + 1, node)
					withAnimation {
						self.nodeComments.insert(node, at: index + 1)
					}
				}
			} else {
				let node = CommentNode(commentThing.data, 0, nil)
				withAnimation {
					self.nodeComments.insert(node, at: 0)
				}
			}
		} else {
			print("\(#function) Something Went Wrong")
		}
	}
}

