//
//  HomeView.swift
//  Orion
//
//  Created by Anil Solanki on 24/09/22.
//

import SwiftUI

struct HomeView: View {

	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var settings : AppSettings

	var items  = [GridItem(.flexible(), spacing: 15),GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]

	var body: some View {
		List {
			Section {
				NavigationLink(value: Destination.HOME) {
					MyLinkRow(title: "Home", symbolName: "house.fill", color: .orange)
				}

				NavigationLink(value: Destination.POPULAR) {
					MyLinkRow(title: "Popular", symbolName: "star.bubble.fill", color: .indigo)
				}

				NavigationLink(value: Destination.All) {
					MyLinkRow(title: "All", symbolName: "square.fill.text.grid.1x2", color: .mint)
				}
			}

			Section {
				NavigationLink(value: Destination.MyCommunities) {
					MyLinkRow(title: "My Communities", symbolName: "list.star", color: .secondary)
				}

				NavigationLink(value: Destination.UserPostList(observedUser.loggedInUser.name)) {
					MyLinkRow(title: "My Posts", symbolName: "square.topthird.inset.filled", color: .secondary)
				}

				NavigationLink(value: Destination.UserUpvoteList(observedUser.loggedInUser.name)) {
					MyLinkRow(title: "Upvoted Posts", symbolName: "arrow.up.square", color: .secondary)
				}

				NavigationLink(value: Destination.SavedPosts(observedUser.loggedInUser.name)) {
					MyLinkRow(title: "Saved Posts", symbolName: "square.and.arrow.down", color: .secondary)
				}
			}

			Section {
				NavigationLink(value: Destination.DiscoverCommunity) {
					RectRowView(title: "Discover Communities", subtitle: "Browse commnunities by categories", symbolName: "doc.text.magnifyingglass")
				}

				NavigationLink(value: Destination.CustomFeedView(observedUser.loggedInUser.name)) {
					RectRowView(title: "Custom Feeds", subtitle: "Customize feeds of your choice", symbolName: "star.square.on.square")
				}
			}

//			if settings.supporter == false {
//				Section {
//					NativeAdView(nativeViewModel: nativeViewModel)
//						.frame(height: 300)
//						.listRowInsets(EdgeInsets())
//				}
//				.listRowBackground(Color.clear)
//			}
		}
		.toolbarBackground(.visible, for: .navigationBar)
	}

	var ProfileHeader: some View {
		return AnyView(Text("SnooRedditUser").font(.title3).textCase(nil))
	}

	private func actionProfile() {

	}
}

