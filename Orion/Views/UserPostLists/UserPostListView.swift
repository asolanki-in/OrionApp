//
//  SharedUserPostListView.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import SwiftUI

struct UserPostListView: View {

	let username: String

	@EnvironmentObject var observedUser : ObservedUser

	@State var paginator = Paginator(after: nil)
	@State var posts = [PostViewModel]()

	@State var sortBy: Sort = Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot")
	@State var presentFilter : Bool = false

	let service = UserDataService()

	var body: some View {
		Group {
			if observedUser.loggedInUser.isAnonymous {
				LoginRequiredView()
			} else {
				if paginator.initialLoading {
					LoaderView().onAppear { self.getPosts() }
				} else {
					if posts.count > 0 {
						postList
					} else {
						tryAgainView
					}
				}
			}
		}
		.navigationTitle(username)
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			if observedUser.loggedInUser.isAnonymous {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						self.presentFilter.toggle()
					}) {
						filterIcon()
					}
				}
			}
		}
		.sheet(isPresented: $presentFilter) {
			FilterView(filterItem: $sortBy, stubs: Sort.userstubs)
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
				PostCardRowView(viewModel: viewModel)
			}
			.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
			.listRowSeparator(.hidden)
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
		case "Controversial":
			return Image(systemName: "bubble.left.and.exclamationmark.bubble.right.fill").tint(.accentColor)
		default:
			return Image(systemName: sortBy.icon).tint(.accentColor)
		}
	}
}

extension UserPostListView {

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
		self.posts.removeAll()
		self.paginator = Paginator(after: nil)
		self.getPosts()
	}

	private func getPosts() {
		if paginator.loadingMore { return }
		paginator.loadingMore = true
		Task(priority: .userInitiated) {
			do {
				let thing = try await service.getPosts(username: username, after: paginator.after, sort: sortBy)
				let tempPosts = thing.data.children.map { thingPost in
					return PostViewModel(post: thingPost.data, listType: .user(username))
				}
				self.serviceCompleted(morePosts: tempPosts, after: thing.data.after, error: nil)
			} catch {
				self.serviceCompleted(morePosts: nil, after: nil, error: error)
			}
		}
	}

	private func getMorePosts(item: PostViewModel) {
		if paginator.loadingMore == true { return }
		if paginator.after == nil { return }
		if self.posts.last?.id == item.id {
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
