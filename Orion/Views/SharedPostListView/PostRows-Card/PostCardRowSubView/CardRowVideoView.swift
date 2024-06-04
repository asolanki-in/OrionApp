//
//  CardRowVideoView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct CardRowVideoView: View {
	@State var presentVideoController: Bool = false

	let VIDEO_URL: URL?
	let LQURL: URL?
	let size: CGSize

	var body: some View {
		Button(action: actionVideoTap) {
			ZStack {
				PostAsycImageView(url: LQURL, size: size)
				Image(systemName: "play.circle.fill")
					.font(.system(size: 60))
					.symbolRenderingMode(.palette)
					.foregroundStyle(.black, .white)
			}
		}
		.buttonStyle(PlainButtonStyle())
		.fullScreenCover(isPresented: $presentVideoController) {
			if let VIDEO_URL {
				PlayerViewController(videoURL: VIDEO_URL).edgesIgnoringSafeArea(.all)
			}
		}
	}

	private func actionVideoTap() {
		presentVideoController.toggle()
	}
}
