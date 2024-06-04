//
//  FullSearchSubredditView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct FullSearchSubredditView: View {

	let query: String
	let service = SearchService()
	@State var paginator = Paginator(after: nil)
	@State var subreddits = [Subreddit]()

	@State var sortBy: Sort = Sort(title: "All Time", children: nil, icon: "infinity", parent: "Relevance", itemValue: "all")
	@State var presentFilter : Bool = false

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
		.navigationTitle("'\(query)'")
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
			FilterView(filterItem: $sortBy, stubs: Sort.searchstubs)
		}
		.onChange(of: sortBy) { [aSort = sortBy] newValue in
			filterChanged(oldValue: aSort, newValue: newValue)
		}
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

extension FullSearchSubredditView {
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
				let thing = try await service.searchSubreddits(query: query, sort: sortBy, after: paginator.after)
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
