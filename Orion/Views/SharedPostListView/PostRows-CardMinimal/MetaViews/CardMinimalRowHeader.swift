//
//  CardMinimalRowHeader.swift
//  Orion
//
//  Created by Anil Solanki on 16/10/22.
//

import SwiftUI

struct CardMinimalRowHeader: View {

	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var router : Router

	let subredditName: String
	let subredditIcon: String
	let timeAgoString: String
	let author: String
	let upvoted : Bool
	let downvoted: Bool
	let bookmarked: Bool
	let listType: PostListType
	let userAction: (PostMoreAction) -> Void
	let shareAction: () -> Void

	var body: some View {
		switch listType {
		case .subreddit(_):
			HStack(alignment: .center, spacing: 12) {
				Text(timeAgoString).font(.footnote).foregroundColor(.secondary)
				Spacer()
				MoreMenuButton()
			}
			.padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
		default:
			HStack(alignment: .center, spacing: 0) {
				Text(subredditName).font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary)
				Text(" · \(timeAgoString)").font(.footnote).foregroundColor(.secondary)
				Spacer()
				MoreMenuButton()
			}
			.padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
		}
	}

	private func SubredditViewButton() -> some View {
		Menu {
			Button(action:actionSubredditView) {
				Label(subredditName, systemImage: "s.circle")
			}

			Button(action: { userAction(.joinSubreddit) }) {
				Label("Join \(subredditName)", systemImage: "plus.square.dashed")
			}
		} label: {
			ImageView(url: subredditIcon, size: .init(width: 30, height: 30), cornerRadius: 6, contentMode: .fill)
			VLabel(primary: subredditName,secondary: timeAgoString)
		}
	}

	private func MoreMenuButton() -> some View {
		Menu {
			Button(action: { userAction(.upvote) }) {
				if upvoted {
					Label("Undo Upvote", systemImage: "arrow.up")
				} else {
					Label("Upvote", systemImage: "arrow.up")
				}
			}

			Button(action: { userAction(.downVote) }) {
				if downvoted {
					Label("Undo Downvote", systemImage: "arrow.down")
				} else {
					Label("Downvote", systemImage: "arrow.down")
				}
			}

			Button(action: { userAction(.save) }) {
				if bookmarked {
					Label("Unsave", systemImage: "bookmark.fill")
				} else {
					Label("Save", systemImage: "bookmark")
				}
			}

			Button(action: { userAction(.copyText) }) {
				Label("Copy Text", systemImage: "doc.on.doc")
			}

			Button(action: { userAction(.hide) }) {
				Label("Hide", systemImage: "eye.slash")
			}

			Button(action:shareAction) {
				Label("Share", systemImage: "square.and.arrow.up.on.square")
			}

			Divider()

			Button(action:actionSubredditView) {
				Label(subredditName, systemImage: "s.circle")
			}

			Button(action:actionUserView) {
				Label("u/\(author)", systemImage: "person")
			}

		} label: {
			Image(systemName: "ellipsis")
				.frame(width: 30, height: 25, alignment: .trailing)
				.contentShape(Rectangle())
				.foregroundColor(.secondary)
		}
	}

	private func actionSubredditView() {
		router.pushView(value: Destination.Subreddit(subredditName))
	}

	private func actionUserView() {
		router.pushView(value: Destination.User(author))
	}

}

extension CardMinimalRowHeader {
	init(post: Post, upvoted: Bool, downvoted: Bool, bookmark: Bool, listType: PostListType, userAction: @escaping (PostMoreAction) -> Void, shareAction: @escaping () -> Void) {
		self.subredditName 	= post.subreddit.displayNamePrefixed
		self.subredditIcon 	= post.subreddit.icon
		self.timeAgoString 	= post.timeAgo
		self.author 		= post.author
		self.upvoted 		= upvoted
		self.downvoted 		= downvoted
		self.bookmarked 	= bookmark
		self.userAction 	= userAction
		self.shareAction 	= shareAction
		self.listType 		= listType
	}
}
