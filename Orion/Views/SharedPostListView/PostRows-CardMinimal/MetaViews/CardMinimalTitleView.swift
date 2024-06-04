//
//  CardMinimalTitleView.swift
//  Orion
//
//  Created by Anil Solanki on 16/10/22.
//

import SwiftUI

struct CardMinimalTitleView: View {
	let title: String
	let markdown: AttributedString?
	var body: some View {
		VStack(alignment: .leading, spacing: 3) {
			if let markdown = markdown {
				Text(title).fontWeight(.medium).foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
				Text(markdown).font(.footnote).foregroundColor(.secondary)
					.lineLimit(3)
					.fixedSize(horizontal: false, vertical: true)
			} else {
				Text(title).fontWeight(.medium).foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.padding(EdgeInsets(top: 0, leading: 15, bottom: 13, trailing: 15))
	}
}

