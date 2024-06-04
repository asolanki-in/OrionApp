//
//  DiscoverSubredditListView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct DiscoverSubredditListView: View {

	let query: String
	let service = SearchService()
	@State var paginator = Paginator(after: nil)
	@State var subreddits = [Subreddit]()
	@State var presentFilter : Bool = false

	var navTitle : String {
		switch query {
		case "default":
			return "All"
		case "popular":
			return "Popular"
		case "new":
			return "New"
		default:
			return query
		}
	}

	var body: some View {
		Group {
			if paginator.initialLoading {
				LoaderView().onAppear { self.getSubreddits()}
			} else {
				if subreddits.count > 0 {
					List {
						Section(header: Text("Communities")) {
							ForEach(subreddits) { subreddit in
								NavigationLink(value: Destination.SubredditPage(subreddit.displayNamePrefixed)) {
									MyCommunitiesRow(subreddit: subreddit)
										.task { getMore(item: subreddit) }
								}
							}
						}
					}
				} else {
					tryAgainView
				}
			}
		}
		.navigationTitle(navTitle)
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarTitleDisplayMode(.inline)
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
}

extension DiscoverSubredditListView {
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
		self.subreddits.removeAll()
	}

	private func getSubreddits() {
		Task(priority: .userInitiated) {
			do {
				let thing = try await service.searchDefaultSubreddits(query: query, after: paginator.after)
				let temp = thing.data.children.map { thingSubreddit in
					return thingSubreddit.data
				}
				await self.serviceCompleted(more: temp, after: thing.data.after, error: nil)
			} catch {
				print(error)
				await self.serviceCompleted(more: nil, after: nil, error: error)
			}
		}
	}

	private func getMore(item: Subreddit) {
		if paginator.loadingMore == true { return }
		if paginator.after == nil { return }
		if self.subreddits.last?.id == item.id {
			paginator.loadingMore = true
			self.getSubreddits()
		}
	}

	@MainActor
	private func serviceCompleted(more: [Subreddit]?, after: String?, error : Error?) {
		if let more { self.subreddits.append(contentsOf: more) }
		paginator.initialLoading = false
		paginator.loadingMore = false
		paginator.after = after
	}
}
