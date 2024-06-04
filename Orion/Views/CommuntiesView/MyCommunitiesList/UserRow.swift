//
//  UserRow.swift
//  Orion
//
//  Created by Anil Solanki on 20/11/22.
//

import SwiftUI

struct UserRow: View {
	let user : User
	var body: some View {
		HStack(alignment: .center, spacing: 15) {
			ImageView(url: user.profileImage, size: .init(width: 40, height: 40), cornerRadius: 10, contentMode: .fill)
			Text(user.name.capitalized).font(.headline)
		}
		.padding(.vertical, 5)
	}
}

struct UserSearchRow: View {
	let user : UserSearchData
	var body: some View {
		HStack(alignment: .center, spacing: 15) {
			ImageView(url: user.icon_img ?? "",
					  size: .init(width: 40, height: 40),
					  cornerRadius: 10,
					  contentMode: .fill)
			VStack(alignment: .leading, spacing: 2) {
				Text(user.name.capitalized).font(.headline)
				Text("u/\(user.name)").font(.footnote).foregroundColor(.secondary)
			}

		}
		.padding(.vertical, 5)
	}
}
