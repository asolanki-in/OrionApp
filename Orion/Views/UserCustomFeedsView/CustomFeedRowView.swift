//
//  CustomFeedRowView.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import SwiftUI

struct CustomFeedRowView: View {

	let title: String
	let subTitle: String?

    var body: some View {
		HStack(spacing: 20) {
			Image(systemName: "square.grid.2x2")
				.font(.system(size:20))
				.foregroundColor(Color.random)
				.frame(width: 30, height: 30,  alignment: .center)
			VStack(alignment: .leading, spacing: 5) {
				Text(title).font(.headline)
				if let subTitle {
					Text(subTitle).font(.footnote).foregroundColor(.secondary)
				}
			}
		}
		.padding(.vertical, 2)
    }
}

