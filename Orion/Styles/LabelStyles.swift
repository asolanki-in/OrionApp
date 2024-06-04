//
//  LabelStyles.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct SettingsLabelStyle: LabelStyle {

	var backgroundColor: Color

	func makeBody(configuration: Configuration) -> some View {
		HStack(spacing: 15) {
			configuration.icon.icon(with: backgroundColor)
			configuration.title.foregroundColor(.primary)
		}
	}
}

struct NormalIconLabel: LabelStyle {
	let spacing: CGFloat
	func makeBody(configuration: Configuration) -> some View {
		HStack(alignment: .center, spacing: spacing) {
			configuration.icon
			configuration.title
		}
	}
}

struct MetaLabel: LabelStyle {
	let spacing: CGFloat
	func makeBody(configuration: Configuration) -> some View {
		HStack(alignment: .center, spacing: spacing) {
			configuration.icon
			configuration.title
		}
		.font(.caption)
		.foregroundColor(.secondary)
	}
}
