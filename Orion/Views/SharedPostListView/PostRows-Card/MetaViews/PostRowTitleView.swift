//
//  PostRowTitleView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 29/07/22.
//

import SwiftUI

struct PostRowTitleView: View {
	let title: String
	let markdown: AttributedString?
	var body: some View {
		VStack(alignment: .leading, spacing: 3) {
			if let markdown = markdown {
				Text(title).font(.title3).fontWeight(.medium).foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
				Text(markdown).font(.footnote).foregroundColor(.secondary)
					.lineLimit(3)
					.fixedSize(horizontal: false, vertical: true)
			} else {
				Text(title).font(.title3).fontWeight(.medium).foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
	}
}

struct PostTitleView: View {
	let title: String
	let markdown: AttributedString?
	var body: some View {
		VStack(alignment: .leading, spacing: 3) {
			if let markdown = markdown {
				Text(title).font(.title3).fontWeight(.medium).foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
				Text(markdown).font(.footnote).foregroundColor(.secondary)
					.fixedSize(horizontal: false, vertical: true)
//					.environment(\.openURL, OpenURLAction { url in
//						handleURLAction(url: url)
//						return .handled
//					})
			} else {
				Text(title).font(.title3).fontWeight(.medium).foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
	}


	private func handleURLAction(url: URL) {
		let type = url.ofType()
		switch type {
		case .LINK:
			print("its a LINK \(url)")
		case .VIDEO:
			print("its a VIDEO \(url)")
		case .IMAGE:
			print("its a IMAGE \(url)")
		case .GIF:
			print("its a GIF \(url)")
		}
	}
}
