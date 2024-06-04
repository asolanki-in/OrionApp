//
//  CardRowGIFView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct CardRowGIFView: View {

	@State var media : URL?
	let post: Post
	let size: CGSize

    var body: some View {
		Button(action: actionGIFTap) {
			ZStack {
				PostAsycImageView(url: post.LQ_IMAGE_URL, size: size)
				Image(systemName: "infinity.circle.fill")
					.font(.system(size: 60))
					.symbolRenderingMode(.palette)
					.foregroundStyle(.black, .white)
			}
		}
		.buttonStyle(PlainButtonStyle())
		.fullScreenCover(item: $media, content: { url in
			if url.absoluteString.contains("mp4") || url.absoluteString.contains("webm") || url.absoluteString.contains("m3u8") {
				//if let url = url {
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
