//
//  CommunityDetailView.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import SwiftUI
import CachedAsyncImage

struct CommunityDetailView: View {

	let name: String
	@State var subreddit: Subreddit?
	@State var loading : Bool = true
	@State var subscribeRunning = false

	let service = SubredditService()

	@State var errorText = "Some Error Occured";

	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var alertManager : AlertManager

    var body: some View {
		Group {
			if loading {
				LoaderView().onAppear { getSubredditData() }
			} else {
				if let subreddit {
					List {
						Section {
							BannerImageView(url: subreddit.banner, color: subreddit.bannerColor).listRowInsets(.init())
							HStack(spacing: 16) {
								ImageView(url: subreddit.icon, size: .init(width: 40, height: 40), cornerRadius: 10, contentMode: .fill)
								VStack(alignment: .leading) {
									Text(subreddit.title).font(.headline).lineLimit(1)
									Text(subreddit.displayNamePrefixed).font(.subheadline).foregroundColor(.secondary)
								}
							}
						}
						.listRowSeparator(.hidden)

						Section {
							NavigationLink(value: Destination.Subreddit(subreddit.displayNamePrefixed)) {
								DetailTextRow(title: "Posts", symbolName: "rectangle.grid.1x2")
							}

							NavigationLink(value: Destination.ModeratorsView(subreddit.displayName)) {
								DetailTextRow(title: "Moderators", symbolName: "person.2.crop.square.stack")
							}
						}

						Section {
							DetailTextRow(title: "Created", subtitle: subreddit.dateString, symbolName: "calendar")
							DetailTextRow(title: "Subscribers", subtitle: subreddit.subscribers?.displayFormat() ?? "0", symbolName: "person.crop.circle")
							DetailTextRow(title: "Online", subtitle: subreddit.activeUserCount?.displayFormat() ?? "0", symbolName: "person.crop.circle.badge.checkmark")
							NavigationLink(value: Destination.RulesView(subreddit.displayName)) {
								DetailTextRow(title: "Rules", symbolName: "exclamationmark.triangle")
							}
							NavigationLink(value: Destination.SubredditAboutView(subreddit.markdown)) {
								DetailTextRow(title: "About", symbolName: "info.circle")
							}
						}
					}
				} else {
					Text(errorText)
				}
			}
		}
		.navigationTitle(name)
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			if loading == false {
				ToolbarItem(placement: .navigationBarTrailing) {
					if subscribeRunning {
						ProgressView()
					} else {
						SubscribeButton
					}
				}
			}
		}
    }


	var SubscribeButton : some View {
		if let subscribed = subreddit?.subscribed, subscribed == true {
			return Button(action: subscribeAction) {
				Text("Leave")
			}
		} else {
			return Button(action: subscribeAction) {
				Text("Join")
			}
		}
	}


	private func subscribeAction() {
		if observedUser.loggedInUser.isAnonymous {
			alertManager.LoginAlert()
		} else {
			subscribe()
		}
	}


	private func getSubredditData() {
		Task(priority: .userInitiated) {
			do {
				let thing = try await service.get(subreddit: name)
				self.serviceCompleted(subreddit: thing, error: nil)
			} catch {
				self.serviceCompleted(subreddit: nil, error: error)
			}
		}
	}

	@MainActor
	private func serviceCompleted(subreddit: Subreddit?, error : Error?) {
		if let subreddit {
			self.subreddit = subreddit
		}

		if let error {
			errorText = error.localizedDescription
		}

		self.loading = false
	}


	func subscribe() {
		if self.subscribeRunning { return }
		self.subscribeRunning = true
		if let subreddit = self.subreddit {
			if let subscribed = subreddit.subscribed {
				self.subscribe(name: subreddit.name, status: !subscribed)
			} else {
				self.subscribeRunning = false
			}
		} else {
			self.subscribeRunning = false
		}
	}

	private func subscribe(name: String, status: Bool) {
		Task.detached(priority: .background) {
			do {
				let thing = try await self.service.joinSubreddit(name: name, status: status)
				await self.completedSubcribe(thing: thing, error: nil)
			} catch  {
				await self.completedSubcribe(thing: nil, error: error)
			}
		}
	}

	@MainActor
	private func completedSubcribe(thing: AnyCodable?, error: Error?) {
		if let error = error {
		} else {
			if let thingCodable = thing, thingCodable.error == nil {
				if let subscribed = subreddit?.subscribed {
					subreddit?.subscribed = !subscribed
				}
			}
		}
		self.subscribeRunning = false
	}
}
