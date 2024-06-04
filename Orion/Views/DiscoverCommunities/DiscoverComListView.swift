//
//  DiscoverComListView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct DiscoverComListView: View {
    var body: some View {
		List {
			Section {
				NavigationLink(value: Destination.DiscoverDefaultList("default")) {
					MyLinkRow(title: "All", symbolName: "capslock.fill", color: .indigo)
				}

				NavigationLink(value: Destination.DiscoverDefaultList("popular")) {
					MyLinkRow(title: "Popular", symbolName: "arrow.up.heart.fill", color: .pink)
				}
			}
			Section {
				ForEach(DiscoverCommunities.categories, id: \.self) { category in
					NavigationLink(value: Destination.FullSearchSubreddit(category.stringValue)) {
						DiscoverCategoryRow(title: category.rawValue, icon: category.icon)
					}
				}
			}
		}
		.navigationTitle("Discover")
    }
}

struct DiscoverComListView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverComListView()
    }
}
