//
//  CardRowVideoLinkView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import BetterSafariView

struct CardRowVideoLinkView: View {

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
				PostAsycImageView(url: LQURL, size: size)
				Image(systemName: "play.circle.fill")
					.font(.system(size: 60))
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
