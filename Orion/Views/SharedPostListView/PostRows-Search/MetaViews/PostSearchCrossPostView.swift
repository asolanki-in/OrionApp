//
//  PostSearchCrossPostView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct PostSearchCrossPostView: View {

	let crossPost: Post
	let mediaSize : CGSize

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(alignment: .top, spacing: 5) {
				VStack(alignment: .leading, spacing: 5) {
					Text(crossPost.subreddit.displayNamePrefixed)
						.font(.subheadline)
						.foregroundColor(.secondary)
					Text(crossPost.title).fixedSize(horizontal: false, vertical: true)
				}
				Spacer()
				postMediaView(postType: crossPost.type, post: crossPost)
			}

			HStack(alignment: .center, spacing: 10) {
				Label("\(crossPost.timeAgo)", systemImage: "clock").labelStyle(MetaLabel(spacing: 2))
				Label("\(crossPost.ups)", systemImage: "arrow.up").labelStyle(MetaLabel(spacing: 2))
				Label("\(crossPost.commentCount)", systemImage: "bubble.right").labelStyle(MetaLabel(spacing: 2))
			}
		}
		.padding(10)
		.cornerRadius(8)
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary, lineWidth: 0.5))
	}

	private func postMediaView(postType: Post.PostType, post: Post) -> some View {
		switch postType {
		case .IMAGE:
			return AnyView(PostSearchImageView(LQURL: post.LQ_IMAGE_URL,
											   HQURL: post.HQ_IMAGE_URL,
											   size: mediaSize))
		case .VIDEO:
			return AnyView(PostSearchVideoView(VIDEO_URL: post.VIDEO_URL,
											   LQURL: post.LQ_IMAGE_URL,
											   size: mediaSize))
		case .LINK:
			return AnyView(PostSearchLinkView(LQURL: post.LQ_IMAGE_URL, url: post.url, size: mediaSize))
		case .GIF:
			return AnyView(PostSearchGIFView(post: post, size: mediaSize))
		case .STREAMABLE, .YOUTUBE:
			return AnyView(PostSearchVideoLinkView(LQURL: post.LQ_IMAGE_URL,
												   VIDEO_LINK: post.VIDEO_URL,
												   size: mediaSize))
		case .GALLERY:
			return AnyView(PostSearchGalleryView(post: post, size: mediaSize))
		case .CROSSPOST:
			return AnyView(EmptyView())
		default:
			return AnyView(EmptyView())
		}
	}

}

