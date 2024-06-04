//
//  PostDetailView.swift
//  Orion
//
//  Created by Anil Solanki on 25/12/22.
//

import SwiftUI

struct PostDetailView: View {

	@ObservedObject var postViewModel : PostViewModel
	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var alertManager : AlertManager
	@State var showActivityView = false
	@State var presentArchivePopup: Bool = false

	@State var activeSheet: SheetTypeDetail?


	private func didAppear() {
		if postViewModel.viewAppear {
			postViewModel.fetchComments()
		}
		postViewModel.viewAppear = false
	}

	var body: some View {
		GeometryReader { geo in
			List {
				Section {
					VStack(alignment: .leading, spacing: 0) {
						PostRowHeader(post: postViewModel.post,
									  upvoted: postViewModel.upvoted,
									  downvoted: postViewModel.downvoted,
									  bookmark: postViewModel.bookmark,
									  listType: .all) { actionType in
							loginRequired(type: actionType)
						} shareAction: {
							self.showActivityView.toggle()
						}

						PostTitleView(title: postViewModel.post.title,
									  markdown: postViewModel.post.markdownStringFull)
						postViewModel.post.linkFlairText.map { _ in PostFlairView(post: postViewModel.post) }
						if postViewModel.post.awardCount > 0 {
							AwardRowView(totalCount: postViewModel.post.awardCount,
										 awardURLs: postViewModel.post.AWARD_URLs)
						} else {
							EmptyView()
						}
						MediaView(type: postViewModel.post.type, size: .init(width: geo.size.width, height: 300))
						PostMetaRowView(actionInProgress: $postViewModel.actionInProgress,
										post: postViewModel.post,
										upvoted: postViewModel.upvoted,
										downvoted: postViewModel.downvoted,
										bookmark: postViewModel.bookmark) { actionType in
							loginRequired(type: actionType)
						}
						Rectangle().frame(height: 15).foregroundColor(.systemGroupedBackground)
					}
				}
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

				if postViewModel.isCommentLoading {
					Section {
						VStack(alignment: .center, spacing: 20) {
							Divider()
							Label("Loading...", systemImage:"hourglass").foregroundColor(.secondary)
							Divider().hidden()
						}
					}
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
				} else {
					if postViewModel.nodeComments.count == 0 {
						Section {
							VStack(alignment: .center, spacing: 20) {
								Text("No Comments").foregroundColor(.secondary)
							}
						}
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
					} else {
						Section {
							ForEach(postViewModel.nodeComments) { node in
								CommentRow(comment: node)
							}
						}
						.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
					}
				}

			}
		}
		.environmentObject(postViewModel)
		.task { didAppear() }
		.environmentObject(postViewModel)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				HStack(spacing: 10) {
					Button(action: actionComment) {
						Image(systemName: "plus.bubble")
					}
					MoreButton
					Button(action: actionPresentFilterView) {
						Image(systemName: postViewModel.filterItem.icon)
							.imageScale(.large)
							.symbolRenderingMode(.hierarchical)
					}
				}
			}
		}
		.listStyle(PlainListStyle())
		.toolbarBackground(.visible, for: .navigationBar)
		.onChange(of: postViewModel.filterItem) { [aSort = postViewModel.filterItem] newValue in
			filterChanged(oldValue: aSort, newValue: newValue)
		}
		.fullScreenCover(isPresented: $showActivityView) {
			ActivityViewController(activityItems: [postViewModel.post.title, postViewModel.post.permalink as Any])
		}
		.sheet(item: $activeSheet, content: { type in
			switch type {
			case .Filter:
				FilterView(filterItem: $postViewModel.filterItem, stubs: Sort.commentstubs)
			case .Commentbox:
				CommentReplyView(comment: nil).environmentObject(postViewModel)
			}
		})
		.alert(isPresented: $presentArchivePopup) {
			Alert(title: Text("Can't Comment"),
				  message: Text("This Post is Archived and users can't comment on it."),
				  dismissButton: .cancel(Text("OK")))
		}
	}

	private func actionPresentFilterView() {
		self.activeSheet = .Filter
	}

	private func filterChanged(oldValue: Sort, newValue: Sort) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			if oldValue.itemValue != newValue.itemValue {
				self.postViewModel.fetchComments(filterItem: postViewModel.filterItem)
			} else if (oldValue.parent != nil) && (oldValue.parent != newValue.parent) {
				self.postViewModel.fetchComments(filterItem: postViewModel.filterItem)
			}
		}
	}

	private func loginRequired(type: PostMoreAction) {
		if observedUser.loggedInUser.isAnonymous {
			alertManager.LoginAlert()
		} else {
			postViewModel.user(type: type)
		}
	}

	private func actionComment() {
		if observedUser.loggedInUser.isAnonymous {
			alertManager.LoginAlert()
		} else {
			if self.postViewModel.post.archived {
				self.presentArchivePopup.toggle()
			} else {
				self.activeSheet = .Commentbox
			}
		}
	}
}

extension PostDetailView {
	func MediaView(type: Post.PostType, size: CGSize) -> some View {

		var newSize = size
		if postViewModel.post.imageSize.height < 300 {
			newSize.height = postViewModel.post.imageSize.height;
		}

		switch type {
		case .IMAGE:
			return AnyView(CardRowImageView(LQURL: postViewModel.post.LQ_IMAGE_URL,
											HQURL: postViewModel.post.HQ_IMAGE_URL,
											size: newSize))
		case .VIDEO:
			return AnyView(CardRowVideoView(VIDEO_URL: postViewModel.post.VIDEO_URL,
											LQURL: postViewModel.post.LQ_IMAGE_URL,
											size: newSize))
		case .LINK:
			return AnyView(CardRowLinkView(LQURL: postViewModel.post.LQ_IMAGE_URL,
										   url: postViewModel.post.url))
		case .TEXT:
			return AnyView(EmptyView())
		case .GIF:
			return AnyView(CardRowGIFView(post: postViewModel.post,
										  size: newSize))
		case .GALLERY:
			return AnyView(CardRowGalleryView(post: postViewModel.post))
		case .STREAMABLE, .YOUTUBE:
			return AnyView(CardRowVideoLinkView(LQURL: postViewModel.post.LQ_IMAGE_URL,
												VIDEO_LINK: postViewModel.post.VIDEO_URL,
												size: newSize))
		case .CROSSPOST:
			if let crosspost = postViewModel.post.crossPost?.first {
				return AnyView(CardRowCrossPostView(post: postViewModel.post,
													crossPost: crosspost))
			} else {
				return AnyView(EmptyView())
			}
		}
	}

	var MoreButton : some View {
		Menu {
			NavigationLink(value: Destination.SubredditPage(postViewModel.post.subreddit.displayNamePrefixed)) {
				Label(postViewModel.post.subreddit.displayNamePrefixed, systemImage: "s.circle")
			}

			NavigationLink(value: Destination.User(postViewModel.post.author)) {
				Label("u/\(postViewModel.post.author)", systemImage: "person")
			}

			Button(action: actionShare) {
				Label("Share", systemImage: "square.and.arrow.up")
			}
		} label: {
			Image(systemName: "ellipsis").frame(width: 40, height: 30, alignment: .trailing)
		}
	}

	private func actionShare() {
		self.showActivityView.toggle()
	}

}


//struct PostDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetailView()
//    }
//}

enum SheetTypeDetail : Identifiable {
	case Filter, Commentbox
	var id: Int {
		hashValue
	}
}
