//
//  PostSearchVideoLinkView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI
import BetterSafariView

struct PostSearchVideoLinkView: View {

	let LQURL : URL?
	let VIDEO_LINK: URL?
	let size: CGSize

	@State var presentVideoController : Bool = false
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	var body: some View {
		Button(action: {
			presentVideoController.toggle()
		}) {
			ZStack {
				SearchImageView(LQURL: LQURL, size: size, corner: 8)
				Image(systemName: "play.circle.fill")
					.font(.system(size: 24))
					.symbolRenderingMode(.palette)
					.foregroundStyle(.black, .white)
			}
		}
		.buttonStyle(PlainButtonStyle())
		.safariView(isPresented: $presentVideoController) {
			SafariView(url: VIDEO_LINK!,
				configuration: SafariView.Configuration(entersReaderIfAvailable: false, barCollapsingEnabled: true)
			)
			.preferredControlAccentColor(Color.tintColors[tintOption])
			.preferredBarAccentColor(.clear)
			.dismissButtonStyle(.done)
		}
	}
}

