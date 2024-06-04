//
//  FullSearchPostView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct FullSearchPostView: View {

	let query: String
	let service = SearchService()

	@EnvironmentObject var observedUser : ObservedUser

	@State var paginator = Paginator(after: nil)
	@State var posts = [PostViewModel]()

	@State var sortBy: Sort = Sort(title: "All Time", children: nil, icon: "infinity", parent: "Relevance", itemValue: "all")
	@State var presentFilter : Bool = false

	var body: some View {
		Group {
			if paginator.initialLoading {
				LoaderView().onAppear { self.getPosts()}
			} else {
				if posts.count > 0 {
					postList
				} else {
					tryAgainView
				}
			}
		}
		.navigationTitle(query)
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: {
					self.presentFilter.toggle()
				}) {
					filterIcon()
				}
			}
		}
		.sheet(isPresented: $presentFilter) {
			FilterView(filterItem: $sortBy, stubs: Sort.postFilterStubData)
		}
		.onChange(of: sortBy) { [aSort = sortBy] newValue in
			filterChanged(oldValue: aSort, newValue: newValue)
		}
//		.onReceive(userManager.userUpdatePublisher) {
//			self.actionRefresh()
//		}

	}

	var tryAgainView : some View {
		VStack(spacing: 5) {
			Text("Something Went Wrong").font(.headline)
			Button(action: actionRefresh) {
				Label("Try Again", systemImage: "arrow.counterclockwise")
			}
			.buttonStyle(.borderless)
		}
	}

	var postList : some View {
		List(posts) { viewModel in
			ZStack {
				NavigationLink(value: Destination.PostDetail(viewModel)) { EmptyView()}
					.buttonStyle(PlainButtonStyle())
					.opacity(0)
				PostSearchRow(viewModel: viewModel)
			}
			.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
			.task { self.getMorePosts(item: viewModel)}
			.background(Color("RowBackground"))
		}
		.listStyle(PlainListStyle())
		.environment(\.defaultMinListRowHeight, 10)
	}

	private func filterIcon() -> some View {
		switch sortBy.parent {
		case "Top":
			return Image(systemName: "chart.bar.xaxis").tint(.accentColor)
		case "Relevance":
			return Image(systemName: "circle.circle").tint(.accentColor)
		case "Comments":
			return Image(systemName: "text.bubble").tint(.accentColor)
		default:
			return Image(systemName: sortBy.icon).tint(.accentColor)
		}
	}
}

extension FullSearchPostView {

	private func filterChanged(oldValue: Sort, newValue: Sort) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			if oldValue.itemValue != newValue.itemValue {
				self.actionRefresh()
			} else if (oldValue.parent != nil) && (oldValue.parent != newValue.parent) {
				self.actionRefresh()
			}
		}
	}

	private func actionRefresh() {
		self.paginator = Paginator(after: nil)
		self.posts.removeAll()
	}

	private func getPosts() {
		Task(priority: .userInitiated) {
			do {
				let thing = try await service.searchPosts(query: query, sort: sortBy, after: paginator.after)
				let tempPosts = thing.data.children.map { thingPost in
					return PostViewModel(post: thingPost.data, listType: .custom(query))
				}
				self.serviceCompleted(morePosts: tempPosts, after: thing.data.after, error: nil)
			} catch {
				print(error)
				self.serviceCompleted(morePosts: nil, after: nil, error: error)
			}
		}
	}

	private func getMorePosts(item: PostViewModel) {
		if paginator.loadingMore == true { return }
		if paginator.after == nil { return }
		if self.posts.last?.id == item.id {
			paginator.loadingMore = true
			self.getPosts()
		}
	}

	@MainActor private func serviceCompleted(morePosts: [PostViewModel]?, after: String?, error : Error?) {
		if let morePosts { self.posts.append(contentsOf: morePosts) }
		paginator.initialLoading = false
		paginator.loadingMore = false
		paginator.after = after
	}
}

