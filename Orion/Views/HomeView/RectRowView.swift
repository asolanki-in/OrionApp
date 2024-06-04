//
//  RectRowView.swift
//  Orion
//
//  Created by Anil Solanki on 24/09/22.
//

import SwiftUI

struct RectRowView: View {

	let title: String
	let subtitle: String
	let symbolName: String

    var body: some View {
		HStack(spacing: 20) {
			Image(systemName: symbolName)
				.font(.system(size:22))
				.fontWeight(.light)
				.frame(width: 30, height: 30,  alignment: .center)
				.foregroundColor(.secondary)
			VStack(alignment: .leading) {
				Text(title)
					.foregroundColor(.primary)
					.font(.body)
				Text(subtitle)
					.foregroundColor(.secondary)
					.font(.footnote)
					.fontWeight(.light)
			}
		}
		.padding(.vertical, 2)
	}

	var roundedRect : some View {
		RoundedRectangle(cornerRadius: 10).strokeBorder(Color(.systemGray6),lineWidth: 1)
	}

}

struct RectRowView_Previews: PreviewProvider {
    static var previews: some View {
		ScrollView {
			RectRowView(title: "Discover Communities",subtitle: "hello", symbolName: "list.triangle")
			Divider()
			RectRowView(title: "Discover Communities",subtitle: "hello", symbolName: "list.triangle")

		}
    }
}
