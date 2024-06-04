//
//  UserView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct UserView: View {

	let username: String
	@StateObject private var observed = Observed()
	@State var shareUserInfo = false

	var body: some View {
		Group {
			if (observed.loading) {
				userDataList(placeholder: true).task { observed.getProfile(name: username)}
			} else {
				if let suspended = observed.user.suspended, suspended == true {
					SuspendView(title: username)
				} else {
					userDataList(placeholder: false)
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("u/\(username)")
		.toolbar {
		  ToolbarItemGroup(placement: .primaryAction) {
			Button(action: actionProfileShare) {
			  Image(systemName: "square.and.arrow.up")
				.symbolRenderingMode(.hierarchical)
			}
		  }
		}
		.sheet(isPresented: $shareUserInfo) {
		  ActivityViewController(activityItems: [URL(string: "https://reddit.com/user/\(username)") as Any])
		}
	}

	private func actionProfileShare() {
	  self.shareUserInfo.toggle()
	}

	@ViewBuilder
	private func userDataList(placeholder: Bool) -> some View {
		List {
			Section(footer: UserKarmaView(user: observed.user)) {
				UserImageView(user: observed.user)
			}
			.textCase(.none)
			.listRowInsets(EdgeInsets())
			.listRowBackground(Color(.systemGroupedBackground))

			Section {
				NavigationLink(value: Destination.UserSharedPostList(.user(username))) {
					DetailTextRow(title: "Posts", symbolName: "rectangle.grid.1x2")
				}
			}

			Section {
				DetailTextRow(title: "Joined",
							  subtitle: observed.user.created?.toString(),
							  symbolName: "calendar")
				DetailTextRow(title: "Awarder Karma",
							  subtitle: "\(observed.user.awarderKarma ?? 0)",
							  symbolName: "gift")
				DetailTextRow(title: "Awardee Karma",
							  subtitle: "\(observed.user.awardeeKarma ?? 0)",
							  symbolName: "gift")
			}

			Section {
				NavigationLink(value: Destination.TrophyListView(username)) {
					DetailTextRow(title: "Trophies", symbolName: "crown")
				}


				NavigationLink(value: Destination.CustomFeedOther(username)) {
					DetailTextRow(title: "Custom Feeds", symbolName: "square.grid.2x2")
				}
				


				//		  NavigationLink(destination: CommentListView(viewModel: CommentListViewModel(observed.user.name))) {
				//			Label("Comments", systemImage: "bubble.right")
				//		  }
			}
		}
		.symbolRenderingMode(.hierarchical)
		.redacted(when: placeholder)
	}

}

struct UserView_Previews: PreviewProvider {
	static var previews: some View {
		UserView(username: "")
	}
}

extension View {
	@ViewBuilder
	func redacted(when condition: Bool) -> some View {
		if !condition {
			unredacted()
		} else {
			redacted(reason: .placeholder)
		}
	}
}
