//
//  CardMinimalMetaRowView.swift
//  Orion
//
//  Created by Anil Solanki on 16/10/22.
//

import SwiftUI

struct CardMinimalMetaRowView: View {

	let ups: Int
	let commentCount: Int
	let author: String

	var body: some View {
		HStack(alignment: .center, spacing: 0) {
			HStack(alignment: .center, spacing: 10) {
				Label("\(ups)", systemImage: "arrow.up").labelStyle(MetaLabel(spacing: 2))
				Label("\(commentCount)", systemImage: "bubble.right").labelStyle(MetaLabel(spacing: 2))
			}
			Spacer()
			Text("u/\(author)").font(.footnote).foregroundColor(.secondary)
		}
		.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
	}
}
