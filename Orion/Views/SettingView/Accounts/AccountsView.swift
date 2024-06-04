//
//  AccountsView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct AccountsView: View {

	@EnvironmentObject var observedUser : ObservedUser

	var body: some View {
		Group {
			//			if observedUser.isUserAnonymous {
			//				LoaderView(message: "Please wait", font: .body)
			//			} else {
			List(observedUser.allUsers, id:\.id) { user in
				if user.name == observedUser.loggedInUser.name {
					AccountCard(user: user, isCurrent: true)
				} else {
					AccountCard(user: user, isCurrent: false)
				}
			}

			//}
		}
		//.disabled(appState.authInProgress)
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Accounts")
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button(action: { observedUser.performLogin() }) {
					NavBarIcon(systemName: "person.fill.badge.plus")
				}
			}
		}
	}
}

struct AccountsView_Previews: PreviewProvider {
	static var previews: some View {
		AccountsView()
	}
}
