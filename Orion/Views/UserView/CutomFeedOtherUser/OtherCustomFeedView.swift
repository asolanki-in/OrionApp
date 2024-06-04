//
//  OtherCustomFeedView.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import SwiftUI

struct OtherCustomFeedView: View {

	@StateObject var observed = Observed()
	let username: String

	var body: some View {
		Group {
			if observed.requestRunning {
				LoaderView().task { await observed.fetchList(username: username) }
			} else {
				if observed.customFeeds.count > 0 {
					List {
						ForEach(observed.customFeeds) { item in
							NavigationLink(value: Destination.Custom(item.feed.path)) {
								CustomFeedRowView(title: item.feed.displayName, subTitle: item.feed.srnamesByComma)
							}
						}
					}
				} else {
					Text(observed.errorMessage)
				}
			}
		}
	}
}

struct OtherCustomFeedView_Previews: PreviewProvider {
	static var previews: some View {
		OtherCustomFeedView(username: "")
	}
}
