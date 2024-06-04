//
//  ScrollerRootView.swift
//  Orion
//
//  Created by Anil Solanki on 11/03/23.
//

import SwiftUI

struct ScrollerRootView: View {

	@StateObject var observed = Observed()

	var body: some View {
		ScrollerSearch(observed: observed)
			.toolbarBackground(.visible, for: .navigationBar)
			.searchable(text: $observed.searchText,
						placement: .navigationBarDrawer(displayMode: .always),
						prompt: "Search a Subreddit")
			.disableAutocorrection(true)

	}
}

struct ScrollerSearch: View {

	@Environment(\.isSearching) var isSearching
	@ObservedObject var observed : ScrollerRootView.Observed
	@State private var presentSwipeView = false
	@State private var selected :Subreddit?

	var body: some View {
		VStack {
			if isSearching {
				if observed.tempSubreddits.count > 0 {
					List {
						Section(header: Text("Communities")) {
							ForEach(observed.tempSubreddits) { result in
								Button(action: {
									self.actionRowTapped(result)
								}) {
									SearchResultRow(title: result.displayNamePrefixed,
													subTitle: result.memberCountString,
													iconString: result.icon,
													nsfw: false)
								}
							}
						}
					}
				}
			} else {
				EmptySearchView(text: "Search a Community and Keep Swiping Posts")
			}
		}

		.fullScreenCover(item: $selected) { selected in
			SwipeView(communityName: selected.displayNamePrefixed)
		}
	}

	private func actionRowTapped(_ subreddit: Subreddit) {
		self.selected = subreddit
	}
}

struct ScrollerRootView_Previews: PreviewProvider {
	static var previews: some View {
		ScrollerRootView()
	}
}
