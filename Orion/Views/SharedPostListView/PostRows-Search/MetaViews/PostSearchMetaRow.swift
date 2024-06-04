//
//  PostSearchMetaRow.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct PostSearchMetaRow: View {

	@EnvironmentObject var router : Router

	@Binding var actionInProgress: Bool
	let post: Post
	let upvoted: Bool
	let downvoted: Bool
	let bookmarked: Bool
	let userAction: (PostMoreAction) -> Void
	let shareAction: () -> Void

	var body: some View {
		HStack(alignment: .center, spacing: 10) {
			Label("\(post.timeAgo)", systemImage: "clock").labelStyle(MetaLabel(spacing: 2))
			Label("\(post.ups)", systemImage: "arrow.up").labelStyle(MetaLabel(spacing: 2))
			Label("\(post.commentCount)", systemImage: "bubble.right").labelStyle(MetaLabel(spacing: 2))
			Spacer()
			MoreMenuButton().disabled(actionInProgress)
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
				Label(post.subreddit.displayNamePrefixed, systemImage: "s.circle")
			}

			Button(action:actionUserView) {
				Label("u/\(post.author)", systemImage: "person")
			}

		} label: {
			Image(systemName: "ellipsis")
				.frame(width: 30, height: 25, alignment: .trailing)
				.contentShape(Rectangle())
				.foregroundColor(.secondary)
		}
	}

	private func actionSubredditView() {
		router.pushView(value: Destination.SubredditPage(post.subreddit.displayNamePrefixed))
	}

	private func actionUserView() {
		router.pushView(value: Destination.User(post.author))
	}
}
