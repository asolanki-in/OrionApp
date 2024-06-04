//
//  ModeratorsView.swift
//  Orion
//
//  Created by Anil Solanki on 10/06/21.
//

import SwiftUI

struct ModeratorsView: View {

	@StateObject var observed = Observed()
	@State var viewAppear = true
	let name: String

	var body: some View {
		VStack {
			if observed.showProgress {
				LoaderView()
			} else {
				if observed.moderators.count > 0 {
					List {
						ForEach(observed.moderators, id: \.id) { moderator in
							NavigationLink(value: Destination.User(moderator.name)) {
								ModeratorRow(name: moderator.name, flairString: moderator.authorFlairText)
							}
							.onAppear {
								self.observed.loadMore(item: moderator, name: name)
							}
						}
					}
				} else {
					Text(observed.errorMessage)
				}
			}
		}
		.navigationTitle("Moderators")
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(.visible, for: .navigationBar)
		.task {
			didAppear()
		}
	}

	private func didAppear() {
		if viewAppear {
			observed.loadModerators(name: name)
		}
		viewAppear = false
	}
}

struct ModeratorsView_Previews: PreviewProvider {
	static var previews: some View {
		ModeratorsView(name: "")
	}
}
