//
//  MyCommunitiesRow.swift
//  Orion
//
//  Created by Anil Solanki on 02/10/22.
//

import SwiftUI

struct MyCommunitiesRow: View {
	let subreddit : Subreddit
	var body: some View {
		HStack(alignment: .center, spacing: 15) {
			ImageView(url: subreddit.icon, size: .init(width: 40, height: 40), cornerRadius: 10, contentMode: .fill)
			VStack(alignment: .leading, spacing: 2) {
				Text(subreddit.displayName.capitalized).font(.headline)
				if let subCount = subreddit.subscribers, subCount != 0 {
					Text("\(subCount) members").font(.caption).foregroundColor(.secondary)
				} else {
					Text(subreddit.displayNamePrefixed).font(.footnote).foregroundColor(.secondary)
				}
			}
		}
		.padding(.vertical, 5)
	}
}
