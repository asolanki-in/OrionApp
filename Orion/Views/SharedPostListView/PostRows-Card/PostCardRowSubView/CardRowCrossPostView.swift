//
//  CardRowCrossPostView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardRowCrossPostView: View {

	let post: Post
	let crossPost: Post

    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			CrossPostRowHeader(post: crossPost)
			CrossPostTitleView(title: crossPost.title)
			switch crossPost.type {
			case .IMAGE:
				CardRowImageView(LQURL: crossPost.LQ_IMAGE_URL, HQURL: crossPost.HQ_IMAGE_URL, size: post.imageSize)
			case .VIDEO:
				CardRowVideoView(VIDEO_URL: crossPost.VIDEO_URL, LQURL: crossPost.LQ_IMAGE_URL, size: post.imageSize)
			case .LINK:
				CardRowLinkView(LQURL: crossPost.LQ_IMAGE_URL, url: crossPost.url)
			case .TEXT:
				EmptyView()
			case .GIF:
				CardRowGIFView(post: crossPost, size: post.imageSize)
//				ZStack {
//					PostAsycImageView(url: crossPost.LQ_IMAGE_URL, size: post.imageSize)
//					Image(systemName: "infinity.circle.fill")
//						.font(.system(size: 60))
//						.symbolRenderingMode(.palette)
//						.foregroundStyle(.black, .white)
//				}
			case .GALLERY:
				CrossPostGalleryView(post: crossPost)
			case .STREAMABLE:
				CardRowVideoLinkView(LQURL: crossPost.LQ_IMAGE_URL, VIDEO_LINK: crossPost.VIDEO_URL, size: post.imageSize)
			case .YOUTUBE:
				CardRowVideoLinkView(LQURL: crossPost.LQ_IMAGE_URL, VIDEO_LINK: crossPost.VIDEO_URL, size: post.imageSize)
			case .CROSSPOST:
				EmptyView()
			}

			CrossPostMetaView(post: crossPost)
		}
		.cornerRadius(8)
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary, lineWidth: 0.5))
		.padding(EdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15))
    }

}

struct CrossPostGalleryView: View {

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
		.frame(height: post.imageSize.height, alignment: .center)
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
				.frame(height: size.height, alignment: .center)
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
				.frame(height: size.height, alignment: .center)
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
