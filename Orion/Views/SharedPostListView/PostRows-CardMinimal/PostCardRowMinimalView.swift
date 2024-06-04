//
//  PostCardRowMinimalView.swift
//  Orion
//
//  Created by Anil Solanki on 16/10/22.
//

import SwiftUI

struct PostCardRowMinimalView: View {

	@ObservedObject var viewModel: PostViewModel
	var post: Post { return viewModel.post }
	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var alertManager : AlertManager

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			CardMinimalRowHeader(post: post,
						  upvoted: viewModel.upvoted,
						  downvoted: viewModel.downvoted,
						  bookmark: viewModel.bookmark,
						  listType: viewModel.listType) { actionType in
				loginRequired(type: actionType)
			} shareAction: {
				let activityVC = UIActivityViewController(activityItems: [post.title, post.permalink as Any], applicationActivities: nil)
				UIApplication.shared.currentUIWindow()?.rootViewController?.present(activityVC, animated: true, completion: nil)
			}

			CardMinimalTitleView(title: post.title, markdown: post.markdownString)
			postMediaView(type: post.type)
			CardMinimalMetaRowView(ups: post.ups, commentCount: post.commentCount, author: post.author)
			Rectangle().frame(height: 10).foregroundColor(.systemGroupedBackground)
		}
	}

	private func loginRequired(type: PostMoreAction) {
		if observedUser.loggedInUser.isAnonymous {
			alertManager.LoginAlert()
		} else {
			viewModel.user(type: type)
		}
	}
}

extension PostCardRowMinimalView {
	func postMediaView(type: Post.PostType) -> some View {
		switch type {
		case .IMAGE:
			return AnyView(CardRowImageView(LQURL: post.LQ_IMAGE_URL, HQURL: post.HQ_IMAGE_URL, size: post.imageSize))
		case .VIDEO:
			return AnyView(CardRowVideoView(VIDEO_URL: post.VIDEO_URL, LQURL: post.LQ_IMAGE_URL, size: post.imageSize))
		case .LINK:
			return AnyView(CardRowLinkView(LQURL: post.LQ_IMAGE_URL, url: post.url))
		case .TEXT:
			return AnyView(EmptyView())
		case .GIF:
			return AnyView(CardRowGIFView(post: post, size: post.imageSize))
		case .GALLERY:
			return AnyView(CardRowGalleryView(post: post))
		case .STREAMABLE, .YOUTUBE:
			return AnyView(CardRowVideoLinkView(LQURL: post.LQ_IMAGE_URL, VIDEO_LINK: post.VIDEO_URL, size: post.imageSize))
		case .CROSSPOST:
			if let crosspost = post.crossPost?.first {
				return AnyView(CardRowCrossPostView(post: post, crossPost: crosspost))
			} else {
				return AnyView(EmptyView())
			}
		}
	}
}
