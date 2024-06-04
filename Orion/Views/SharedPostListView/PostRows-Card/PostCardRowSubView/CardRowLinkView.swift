//
//  CardRowLinkView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import BetterSafariView

struct CardRowLinkView: View {
	@State var presentingSafariView = false
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	let LQURL: URL?
	let url: String?

    var body: some View {
		PostLinkView(imageUrl: LQURL, link: url, action: actionPresentSafari)
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
