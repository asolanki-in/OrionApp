//
//  PostMetaRowView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 31/07/22.
//

import SwiftUI

struct PostMetaRowView: View {

	@Binding var actionInProgress: Bool
	let post: Post
	let upvoted: Bool
	let downvoted: Bool
	let bookmark: Bool
	let userAction: (PostMoreAction) -> Void

	var body: some View {
		HStack(alignment: .center, spacing: 0) {
			VStack(alignment: .leading, spacing: 5) {
				Text("u/\(post.author)").font(.subheadline).foregroundColor(.secondary)
				HStack(alignment: .center, spacing: 10) {
					Label("\(post.ups)", systemImage: "arrow.up").labelStyle(MetaLabel(spacing: 2))
					Label("\(post.commentCount)", systemImage: "bubble.right").labelStyle(MetaLabel(spacing: 2))
				}
			}
			Spacer()
			HStack(alignment: .center, spacing: 15) {
				upvoteView()
				downvoteView()
				bookmarkView()
			}
			.disabled(actionInProgress)
		}
		.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
	}

	private func upvoteView() -> some View {
		Button(action: { userAction(.upvote) }) {
			if upvoted {
				Image(systemName: "arrow.up")
					.fontWeight(.heavy)
					.foregroundColor(.purple)
					.frame(width: 30, height: 25, alignment: .trailing)
					.contentShape(Rectangle())
			} else {
				Image(systemName: "arrow.up")
					.frame(width: 30, height: 25, alignment: .trailing)
					.contentShape(Rectangle())
			}
		}
		.buttonStyle(PlainButtonStyle())
	}

	private func downvoteView() -> some View {
		Button(action: { userAction(.downVote) }) {
			if downvoted {
				Image(systemName: "arrow.down")
					.fontWeight(.heavy)
					.foregroundColor(.pink)
					.frame(width: 30, height: 25, alignment: .trailing)
					.contentShape(Rectangle())
			} else {
				Image(systemName: "arrow.down")
					.frame(width: 30, height: 25, alignment: .trailing)
					.contentShape(Rectangle())
			}
		}
		.buttonStyle(PlainButtonStyle())
	}

	private func bookmarkView() -> some View {
		Button(action: { userAction(.save) }) {
			if bookmark {
				Image(systemName: "bookmark.fill")
					.fontWeight(.heavy)
					.foregroundColor(.green)
					.frame(width: 30, height: 25, alignment: .trailing)
					.contentShape(Rectangle())
			} else {
				Image(systemName: "bookmark")
					.frame(width: 30, height: 25, alignment: .trailing)
					.contentShape(Rectangle())
			}
		}
		.buttonStyle(PlainButtonStyle())
	}
}

//struct PostMetaRowView_Previews: PreviewProvider {
//	static var previews: some View {
//		PostMetaRowView()
//	}
//}
