//
//  PostSearchGalleryView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct PostSearchGalleryView: View {

	@State var presentFullScreenGallery: Bool = false
	let post : Post
	let size: CGSize

	var LQURL : URL? {
		if let u = post.galleryMedia.first?.u {
			return URL(string: u)
		}
		return nil
	}

	var body: some View {
		Button(action: actionTap) {
			ZStack {
				if (post.galleryMedia.count > 0) {
					SearchImageView(LQURL: LQURL, size: size, corner: 8)
				} else {
					SearchImageView(LQURL: post.LQ_IMAGE_URL, size: size, corner: 8)
				}
				Image(systemName: "rectangle.fill.on.rectangle.fill")
					.font(.system(size: 24))
					.symbolRenderingMode(.palette)
					.foregroundStyle(.white, .black)
			}
		}
		.buttonStyle(PlainButtonStyle())
		.fullScreenCover(isPresented: $presentFullScreenGallery) {
			FullScreenGalleryView(size: post.imageSize, galleryMedia: post.galleryMedia)
				.environment(\.colorScheme,  .dark)
		}
	}

	private func actionTap() {
		self.presentFullScreenGallery.toggle()
	}

}
