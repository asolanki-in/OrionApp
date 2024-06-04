//
//  PostSearchLinkView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI
import BetterSafariView

struct PostSearchLinkView: View {
	@State var presentingSafariView = false
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	let LQURL: URL?
	let url: String?
	let size: CGSize

	var body: some View {
		ZStack(alignment: .center) {
			if let url = LQURL, url.absoluteString.isEmpty == false {
				SearchImageView(LQURL: LQURL, size: size, corner: 8)
			} else {
				Rectangle()
					.frame(width: size.width, height: size.height)
					.foregroundColor(Color(.systemGray4))
					.cornerRadius(8)
					.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray5), lineWidth: 1))
			}

			Image(systemName: "safari.fill")
				.font(.system(size: 24))
				.symbolRenderingMode(.palette)
				.foregroundStyle(.black, .white)
		}
		.onTapGesture {
			actionPresentSafari()
		}
		.safariView(isPresented: $presentingSafariView) {
			SafariView(url: URL(string: url ?? "")!,
					   configuration: SafariView.Configuration(entersReaderIfAvailable: false, barCollapsingEnabled: true)
			)
			.preferredControlAccentColor(Color.tintColors[tintOption])
			.preferredBarAccentColor(.clear)
			.dismissButtonStyle(.done)
		}
	}

	private func actionPresentSafari() {
		self.presentingSafariView.toggle()
	}

}
