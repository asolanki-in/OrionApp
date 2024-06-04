//
//  PostLinkView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 14/08/22.
//

import SwiftUI

struct PostLinkView: View {

	let imageUrl: URL?
	let link: String?
	let action: () -> Void

    var body: some View {
		Button(action: action) {
			HStack(alignment: .center, spacing: 10) {
				if let url = imageUrl, url.absoluteString.isEmpty == false {
					ImageView(url: url.absoluteString, size: .init(width: 50, height: 50), contentMode: .fill)
				} else {
					Image(systemName: "safari.fill")
						.imageScale(.large)
						.frame(width: 50, height: 50)
						.symbolRenderingMode(.hierarchical)
						.background(Color(.systemGray4))
				}
				if let hostURL = URL(string: link ?? ""), let host = hostURL.host() {
					VStack(alignment: .leading, spacing: 0) {
						Text(host).font(.subheadline)
						Text(hostURL.absoluteString)
							.font(.footnote)
							.foregroundColor(.secondary)
					}
					.lineLimit(1)
					.padding(.trailing, 10)
				} else {
					Text(link ?? "").font(.footnote)
						.font(.caption)
						.foregroundColor(.secondary)
						.lineLimit(1)
						.padding(.trailing, 10)

				}
			}
			.frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
			.background(Color(.systemGray5))
			.cornerRadius(8)
			.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray5), lineWidth: 1))
			.clipped()
			.padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
		}
		.buttonStyle(PlainButtonStyle())
    }
}

struct PostLinkView_Previews: PreviewProvider {
    static var previews: some View {
		PostLinkView(imageUrl: URL(string: ""), link: "") {

		}
    }
}
