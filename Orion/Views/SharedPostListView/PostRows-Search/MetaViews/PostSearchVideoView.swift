//
//  PostSearchVideoView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct PostSearchVideoView: View {
	@State var presentVideoController: Bool = false

	let VIDEO_URL: URL?
	let LQURL: URL?
	let size: CGSize

	var body: some View {
		Button(action: actionVideoTap) {
			ZStack {
				SearchImageView(LQURL: LQURL, size: size, corner: 8)
				Image(systemName: "play.circle.fill")
					.font(.system(size: 24))
					.symbolRenderingMode(.palette)
					.foregroundStyle(.black, .white)
			}
		}
		.buttonStyle(PlainButtonStyle())
		.fullScreenCover(isPresented: $presentVideoController) {
			if let url = VIDEO_URL {
				PlayerViewController(videoURL: url).edgesIgnoringSafeArea(.all)
			}
		}
	}

	private func actionVideoTap() {
		presentVideoController.toggle()
	}
}

