//
//  DiscoverCategoryRow.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct DiscoverCategoryRow: View {

	let title: String
	let icon: String

	var body: some View {
		HStack(spacing: 20) {
			Image(icon)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 30, height: 25,  alignment: .center)
			Text(title).font(.body)
		}
		.padding(.vertical, 6)
	}
}
