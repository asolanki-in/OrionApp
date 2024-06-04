//
//  AccountCard.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct AccountCard: View {

	@EnvironmentObject var observedUser : ObservedUser

	let user: AppUser
	let isCurrent: Bool

	var body: some View {
		HStack(alignment: .center, spacing: 15) {
			IconImageView(url: user.profileImage, size: .init(width: 60, height: 80))
			TitleView
			Spacer()
			checkmarkButton
		}
		.swipeActions(allowsFullSwipe: false) {
			if user.name != AppUser.anonymous.name {
				Button(role: .destructive) {
					self.actionLogout()
				} label: {
					Label("Logout", systemImage: "trash.fill").imageScale(.large)
				}
			}
		}
	}

	var TitleView : some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(user.displayName).font(.headline)
			Label("\(user.total_karma) karma", systemImage: "hand.raised.fingers.spread.fill")
				.labelStyle(NormalIconLabel(spacing: 5))
				.font(.footnote)
		}
	}

	var checkmarkButton : some View {
		Button(action: actionChange) {
			if isCurrent {
				Image(systemName: "checkmark.square.fill").imageScale(.large)
			} else {
				Image(systemName: "square").imageScale(.large)
			}
		}
		.buttonStyle(PlainButtonStyle())
		.contentShape(Rectangle())
	}

	func actionChange() {
		withAnimation {
			observedUser.switchUser(user)
		}
	}

	private func actionLogout() {
		observedUser.delete(user.name)
	}
}
