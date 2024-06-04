//
//  SearchView.swift
//  Orion
//
//  Created by Anil Solanki on 20/11/22.
//

import SwiftUI

struct SearchView: View {

	@StateObject private var viewModel = SearchViewModel();

	var body: some View {
		SearchListView(viewModel: viewModel)
			.toolbarBackground(.visible, for: .navigationBar)
			.searchable(text: $viewModel.searchText,
						placement: .navigationBarDrawer(displayMode: .always),
						prompt: "Enter a keyword")
			.disableAutocorrection(true)
	}
}

struct SearchListView: View {

	@Environment(\.isSearching) var isSearching
	@ObservedObject var viewModel : SearchViewModel

	var body: some View {
		VStack {
			if isSearching {
				List {
					if (viewModel.searchText.isEmpty == false) {
						Section(header: Text("Search Posts")) {
							NavigationLink(value: Destination.FullSearchPostView(viewModel.searchText)) {
								SearchMoreRow(query: viewModel.searchText, searchtype: .pst)
							}
						}

						if viewModel.tempSubreddits.count > 0 {
							Section(header: Text("Communities")) {
								ForEach(viewModel.tempSubreddits) { result in
									NavigationLink(value: Destination.SubredditPage(result.displayNamePrefixed)) {
										SearchResultRow(title: result.displayNamePrefixed,
														subTitle: result.memberCountString,
														iconString: result.icon,
														nsfw: false)
									}
								}

								NavigationLink(value: Destination.FullSearchSubreddit(viewModel.searchText)) {
									SearchMoreRow(query: viewModel.searchText, searchtype: .sr)
								}
							}
						}

						if viewModel.tempUsers.count > 0 {
							Section(header: Text("Users")) {
								ForEach(viewModel.tempUsers) { result in
									NavigationLink(value: Destination.User(result.name)) {
										SearchResultRow(title: result.name,
														subTitle: "u/\(result.name)",
														iconString: result.profileImageString, nsfw: false)
									}
								}
								NavigationLink(value: Destination.FullSearchUser(viewModel.searchText)) {
									SearchMoreRow(query: viewModel.searchText, searchtype: .usr)
								}
							}
						}
					}
				}
			} else {
				EmptySearchView(text: "Enter a keyword & get list of Communities,\nUsers & Posts.")
			}
		}
		.onChange(of: isSearching) { newValue in
			if !newValue {
				viewModel.emptyData()
			}
		}
	}
}
