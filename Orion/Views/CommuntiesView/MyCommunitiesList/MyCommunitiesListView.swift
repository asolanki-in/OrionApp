//
//  MyCommunitiesListView.swift
//  Orion
//
//  Created by Anil Solanki on 02/10/22.
//

import SwiftUI

struct MyCommunitiesListView: View {

	@State var subreddits = [SubredditViewModel]()
	@State var users = [SubredditViewModel]()
	@State var paginator = Paginator(after: nil)
	@EnvironmentObject var observedUser : ObservedUser

	let service = UserDataService()

	var body: some View {
		Group {
			if observedUser.loggedInUser.isAnonymous {
				LoginRequiredView()
			} else {
				if paginator.initialLoading {
					LoaderView().onAppear { self.fetchMyCommunities()}
				} else {

					if users.count == 0 && subreddits.count == 0 {
						Text("No Data").font(.headline)
					} else {
						List {
							if subreddits.count > 0 {
								Section(header: Text("Communities")) {
									ForEach(subreddits) { item in
										NavigationLink(value: Destination.SubredditPage(item.subreddit.displayNamePrefixed)) {
											MyCommunitiesRow(subreddit: item.subreddit)
											.task {
												if item.id == subreddits.last?.id {
													loadMore()
												}
											}
										}
									}
								}
							}

							if users.count > 0 {
								Section(header: Text("Users")) {
									ForEach(users) { item in
										MyCommunitiesRow(subreddit: item.subreddit)
										.task {
											if item.id == users.last?.id {
												loadMore()
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		.navigationTitle("MyCommunities")
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarTitleDisplayMode(.inline)
	}
}

extension MyCommunitiesListView {

	private func loadMore() {
		if paginator.loadingMore { return }
		if paginator.after == nil { return }
		paginator.loadingMore = true
		fetchMyCommunities()
	}

	private func fetchMyCommunities() {
		Task.detached(priority: .userInitiated) {
			do {
				let thing = try await self.service.getMySubscription(after: paginator.after)
				var children =  thing.data.children
				children.sort { $0.data.displayName.caseInsensitiveCompare($1.data.displayName)  == .orderedAscending }
				let temp = children.map { SubredditViewModel(subreddit: $0.data) }
				let temusers = temp.filter { $0.subreddit.subredditType == "user" }
				let tempsr = temp.filter { $0.subreddit.subredditType == "public" }
				await MainActor.run { paginator.after =  thing.data.after }
				await self.completed(tempsr, temusers, thing.data.after, error: nil)
			} catch {
				await self.completed(nil, nil, nil, error: error)
			}
		}
	}

	@MainActor func completed(_ items: [SubredditViewModel]?, _ users: [SubredditViewModel]?, _ after: String?, error: Error?) async {
		if let items {
			self.subreddits.append(contentsOf: items)
			if let users = users {
				self.users.append(contentsOf: users)
			}
		}
		paginator.initialLoading = false
		paginator.loadingMore = false
		paginator.after = after
	}
}

struct MyCommunitiesListView_Previews: PreviewProvider {
	static var previews: some View {
		MyCommunitiesListView()
	}
}
