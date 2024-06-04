//
//  SettingUserRow.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import CachedAsyncImage

struct SettingUserRow: View {

	@EnvironmentObject var observedUser : ObservedUser

	let imageSize : CGSize = .init(width: 70, height: 90)

	var profileImageURL : URL? {
		return observedUser.loggedInUser.profileImage
	}

    var body: some View {
		HStack(spacing: 15) {
			IconImageView(url: profileImageURL, size: imageSize)
			UserView
		}
    }

	var AnonymousView : some View {
		VStack(alignment:.leading) {
			Text("Annonymous").font(.title3).bold()
		}
	}

	var UserView : some View {
		VStack(alignment:.leading) {
			Text(observedUser.loggedInUser.displayName).font(.title3).bold()
			if observedUser.loggedInUser.isAnonymous {
				Text("Login with a reddit account.").font(.subheadline).foregroundColor(.secondary)
			} else {
				Text("Tap to get profile infomation.").font(.subheadline).foregroundColor(.secondary)
			}
		}
	}
}

struct SettingUserRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingUserRow()
    }
}
