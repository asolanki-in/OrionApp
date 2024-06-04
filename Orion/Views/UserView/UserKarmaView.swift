//
//  UserKarmaView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct UserKarmaView: View {
	let user: User
	var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
	var body: some View {
		LazyVGrid(columns: gridItems, alignment: .center, spacing: 5) {
			VStack(alignment: .center) {
				Text("Total Karma")
					.font(.caption)
					.foregroundColor(.secondary)
				Text("\(user.totalKarma ?? 0)").font(.title3)
			}.padding(5)

			VStack(alignment: .center) {
				Text("Post Karma")
					.font(.caption)
					.foregroundColor(.secondary)
				Text("\(user.linkKarma ?? 0)").font(.title3)
			}.padding(5)

			VStack(alignment: .center) {
				Text("Comment Karma")
					.font(.caption)
					.foregroundColor(.secondary)
				Text("\(user.commentKarma ?? 0)").font(.title3)
			}.padding(5)

		}
		.padding(.top, 10)
	}
}

