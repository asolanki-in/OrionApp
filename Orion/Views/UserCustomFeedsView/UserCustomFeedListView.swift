//
//  UserCustomFeedListView.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import SwiftUI

struct UserCustomFeedListView: View {

	let username: String
	@State var customFeeds = [CustomFeedViewModel]()
	@State var loading = true
	@EnvironmentObject var observedUser : ObservedUser

	let service = UserDataService()

	var body: some View {
		Group {
			if observedUser.loggedInUser.isAnonymous {
				LoginRequiredView()
			} else {
				if loading {
					LoaderView().onAppear { self.fetchCustomFeeds()}
				} else {
					if customFeeds.count > 0 {
						List {
							ForEach(customFeeds) { item in
								NavigationLink(value: Destination.Custom(item.feed.path)) {
									CustomFeedRowView(title: item.feed.displayName, subTitle: item.feed.srnamesByComma)
								}
							}
						}
					} else {
						tryAgainView
					}
				}
			}
		}
		.navigationTitle("Custom Feeds")
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarTitleDisplayMode(.inline)
	}

	var tryAgainView : some View {
		VStack(spacing: 5) {
			Text("No Data Found").font(.headline)
			Button(action: actionRefresh) {
				Label("Try Again", systemImage: "arrow.counterclockwise")
			}
			.buttonStyle(.borderless)
		}
	}
}

extension UserCustomFeedListView {

	private func actionRefresh() {
		self.customFeeds.removeAll()
		self.loading = true
	}

	private func fetchCustomFeeds() {
		Task.detached(priority: .userInitiated) {
			do {
				let thing = try await self.service.getCustomFeed()
				let items = thing.map({ nulti in
					CustomFeedViewModel(feed: nulti.data)
				})
				await self.completed(items, error: nil)
			} catch {
				await self.completed(nil, error: error)
			}
		}
	}

	@MainActor func completed(_ items: [CustomFeedViewModel]?, error: Error?) async {
		if let items {
			self.customFeeds.append(contentsOf: items)
		}
		loading = false
	}
}
