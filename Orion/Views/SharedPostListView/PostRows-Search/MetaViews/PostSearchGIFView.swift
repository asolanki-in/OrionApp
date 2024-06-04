//
//  PostSearchGIFView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct PostSearchGIFView: View {

	@State var media : URL?
	let post: Post
	let size: CGSize

	var body: some View {
		Button(action: actionGIFTap) {
			ZStack {
				SearchImageView(LQURL: post.LQ_IMAGE_URL, size: size, corner: 8)
				Image(systemName: "infinity.circle.fill")
					.font(.system(size: 24))
					.symbolRenderingMode(.palette)
					.foregroundStyle(.black, .white)
			}
		}
		.buttonStyle(PlainButtonStyle())
		.fullScreenCover(item: $media, content: { url in
			if url.absoluteString.contains("mp4") || url.absoluteString.contains("webm") || url.absoluteString.contains("m3u8") {
				//if let url {
					PlayerViewController(videoURL: url).edgesIgnoringSafeArea(.all)
				//}
			} else {
				FullScreenGIFView(gifURL: url)
			}
		})
	}

	private func actionGIFTap() {
		if let mp4 = post.preview?.images.first?.variants?.mp4 {
			self.media = URL(string: mp4.source.url)
		} else if let videoPreview = post.preview?.redditVideoPreview?.hlsURL {
			self.media = URL(string: videoPreview)
		} else if let gifURL = post.GIF_URL, gifURL.host()?.contains("imgur") == true {
			self.media = gifURL.deletingPathExtension().appendingPathExtension("mp4")
		} else if let gifURL = post.GIF_URL {
			self.media = gifURL
		} else {
			print("here")
		}
	}
}

