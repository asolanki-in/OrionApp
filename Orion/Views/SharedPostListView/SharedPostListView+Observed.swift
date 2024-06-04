//
//  SharedPostListView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import Foundation

extension SharedPostListView {
	final class Observed: ObservableObject {

		@Published var posts = [PostViewModel]()
		@Published var paginator = Paginator(after: nil)

		let service = PostService()
		var errorMessage = "Something Went Wrong"

		public func reset(_ type: PostListType, _ sort: Sort) {
			self.paginator = Paginator(after: nil)
			self.posts.removeAll()
		}

		public func getPosts(type: PostListType, sort: Sort) {
			if self.paginator.loadingMore {
				return
			}
			self.paginator.loadingMore = true
			Task(priority: .userInitiated) {
				await fetchPosts(listType: type, sort: sort)
			}
		}

		public func getMore(_ item: PostViewModel, _ type: PostListType, _ sort: Sort) {
			if paginator.loadingMore == true { return }
			if paginator.after == nil { return }
			if self.posts.last?.id == item.id {
				self.getPosts(type: type, sort: sort)
			}
		}

		private func fetchPosts(listType: PostListType, sort: Sort) async {
			do {
				let thing = try await service.getPosts(listType, sort: sort, after: paginator.after)
				let temp = thing.data.children.map { thingPost in
					return PostViewModel(post: thingPost.data, listType: listType)
				}
				await self.serviceCompleted(more: temp, after: thing.data.after, error: nil)
			} catch {
				await self.serviceCompleted(more: nil, after: nil, error: error)
			}
		}

		@MainActor
		private func serviceCompleted(more: [PostViewModel]?, after: String?, error : Error?) {
			if let error {
				print(error)
				if self.posts.count == 0 {
					errorMessage = error.localizedDescription
				}
			}

			if let morePosts = more {
				self.posts.append(contentsOf: morePosts)
			}

			paginator.after = after
			paginator.initialLoading = false
			paginator.loadingMore = false

		}
	}
}
