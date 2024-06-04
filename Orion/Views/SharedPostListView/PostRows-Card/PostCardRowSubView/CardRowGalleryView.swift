//
//  CardRowGalleryView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardRowGalleryView: View {

	@State var presentFullScreenGallery: Bool = false
	let post : Post

    var body: some View {
		TabView {
			ForEach(post.galleryMedia, id:\.self) { media in
				if let u = media.u {
					ImageSView(mediaURL: URL(string: u), size: post.imageSize, caption: media.caption)
				} else if let gif = media.gif {
					GIFView(mediaURL: URL(string: gif), size: post.imageSize, caption: media.caption)
				} else {
					EmptyView()
				}
			}
			.onTapGesture {
				self.presentFullScreenGallery.toggle()
			}
		}
		.frame(width: UIScreen.screenWidth, height: post.imageSize.height)
		.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
		.fullScreenCover(isPresented: $presentFullScreenGallery) {
			FullScreenGalleryView(size: post.imageSize, galleryMedia: post.galleryMedia)
				.environment(\.colorScheme,  .dark)
		}
	}

	@ViewBuilder
	private func GIFView(mediaURL: URL?, size: CGSize, caption: String?) -> some View {
		ZStack(alignment: .top) {
			WebImage(url: mediaURL)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: size.width, height: size.height, alignment: .center)
				.background(Color(.systemGray5))
			if let caption = caption?.trimmingCharacters(in: .whitespacesAndNewlines) {
				Text(caption)
					.font(.footnote)
					.multilineTextAlignment(.leading)
					.frame(maxWidth: .infinity)
					.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
					.background(.ultraThinMaterial)
			}
		}
	}

	@ViewBuilder
	private func ImageSView(mediaURL: URL?, size: CGSize, caption: String?) -> some View {
		ZStack(alignment: .top) {
			WebImage(url: mediaURL)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: size.width, height: size.height, alignment: .center)
				.background(Color(.systemGray5))
			if let caption = caption?.trimmingCharacters(in: .whitespacesAndNewlines) {
				Text(caption)
					.font(.footnote)
					.multilineTextAlignment(.leading)
					.frame(maxWidth: .infinity)
					.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
					.background(.ultraThinMaterial)
			}
		}
	}

}
