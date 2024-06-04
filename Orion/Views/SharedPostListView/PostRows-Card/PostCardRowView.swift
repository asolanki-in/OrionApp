//
//  PostCardRowView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct PostCardRowView: View {

	@ObservedObject var viewModel: PostViewModel
	var post: Post { return viewModel.post }
	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var alertManager : AlertManager
	@State var showActivityView = false

    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			PostRowHeader(post: post,
						  upvoted: viewModel.upvoted,
						  downvoted: viewModel.downvoted,
						  bookmark: viewModel.bookmark,
						  listType: viewModel.listType) { actionType in
				loginRequired(type: actionType)
			} shareAction: {
				self.showActivityView.toggle()
			}

			PostRowTitleView(title: post.title, markdown: post.markdownString)
			post.linkFlairText.map { _ in PostFlairView(post: post) }
			if post.awardCount > 0 {
				AwardRowView(totalCount: post.awardCount, awardURLs: post.AWARD_URLs)
			} else {
				EmptyView()
			}
			postMediaView(type: post.type)
			PostMetaRowView(actionInProgress: $viewModel.actionInProgress,
							post: post,
							upvoted: viewModel.upvoted,
							downvoted: viewModel.downvoted,
							bookmark: viewModel.bookmark) { actionType in
				loginRequired(type: actionType)
			}
			Rectangle().frame(height: 10).foregroundColor(.systemGroupedBackground)
		}
		.sheet(isPresented: $showActivityView) {
			ActivityViewController(activityItems: [post.title, post.permalink as Any])
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

extension PostCardRowView {
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
