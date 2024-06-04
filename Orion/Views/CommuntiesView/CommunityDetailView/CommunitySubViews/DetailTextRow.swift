//
//  DetailTextRow.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import SwiftUI

struct DetailTextRow: View {

	let title: String
	let subtitle: String?
	let symbolName: String

	init(title: String, subtitle: String?, symbolName: String) {
		self.title = title
		self.subtitle = subtitle
		self.symbolName = symbolName
	}

	init(title: String, symbolName: String) {
		self.title = title
		self.subtitle = nil
		self.symbolName = symbolName
	}

	var body: some View {
		HStack(alignment: .center, spacing: 15) {
			Image(systemName: symbolName)
				.font(.system(size: 20, weight: .regular))
				.frame(width: 30, height: 20)
				.foregroundColor(.secondary)
			Text(title)
			Spacer()
			if let subtitle {
				Text(subtitle).font(.subheadline).foregroundColor(.secondary)
			}
		}
		.padding(.vertical, 8)
	}
}
