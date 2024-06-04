//
//  SearchResultRow.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct SearchResultRow: View {
	let title: String
	let subTitle: String
	let iconString: String
	let nsfw: Bool

	let size : CGSize = .init(width: 30, height: 30)

	var body: some View {
		HStack(alignment: .center, spacing: 15) {
			ImageView(url: iconString, size: size, cornerRadius: 6, contentMode: .fill)
			VStack(alignment: .leading, spacing: 2) {
				Text(title).font(.headline).foregroundColor(.primary)
				Text(subTitle).font(.caption).foregroundColor(.secondary)
			}
		}
	}
}
