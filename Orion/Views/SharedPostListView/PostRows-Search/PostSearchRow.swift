//
//  PostSearchRow.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct PostSearchRow: View {

	@ObservedObject var viewModel: PostViewModel
	var post: Post { return viewModel.post }
	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var alertManager : AlertManager
	@State var showActivityView = false


	let mediaSize : CGSize = .init(width: 100, height: 70)

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			if (post.type == .CROSSPOST) {
				VStack(alignment: .leading, spacing: 5) {
					Text(post.subreddit.displayNamePrefixed)
						.font(.subheadline)
						.foregroundColor(.secondary)
					Text(post.title).font(.headline)
						.fixedSize(horizontal: false, vertical: true)
				}

				postMediaView(type: post.type)

			} else {
				HStack(alignment: .top, spacing: 5) {
					VStack(alignment: .leading, spacing: 5) {
						Text(post.subreddit.displayNamePrefixed)
							.font(.subheadline)
							.foregroundColor(.secondary)
						Text(post.title).font(.headline)
							.fixedSize(horizontal: false, vertical: true)
					}
					Spacer()
					postMediaView(type: post.type)
				}
			}

			PostSearchMetaRow(actionInProgress: $viewModel.actionInProgress,
							  post: post,
							  upvoted: viewModel.upvoted,
							  downvoted: viewModel.downvoted,
							  bookmarked: viewModel.bookmark) { actionType in
				loginRequired(type: actionType)
			} shareAction: {
				self.showActivityView.toggle()
			}
		}
		.padding(.horizontal, 15)
		.padding(.vertical, 8)
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

	func postMediaView(type: Post.PostType) -> some View {
		switch type {
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
			if let crosspost = post.crossPost?.first {
				return AnyView(PostSearchCrossPostView(crossPost: crosspost, mediaSize: mediaSize))
			} else {
				return AnyView(EmptyView())
			}
		default:
			return AnyView(EmptyView())
		}
	}
	
}
