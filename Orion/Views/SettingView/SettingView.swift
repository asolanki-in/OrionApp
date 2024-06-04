//
//  SettingView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct SettingView: View {

	@EnvironmentObject var observedUser : ObservedUser

	var body: some View {
		Form {
			Section {
				if observedUser.loggedInUser.isAnonymous {
					SettingUserRow()
				} else {
					NavigationLink(value: Destination.UserProfile) {
						SettingUserRow()
					}
				}
			}

			Section {
				NavigationLink(value: Destination.General) {
					SettingRow(title: "General", systemImage: "gearshape.fill", backgroundColor: .gray)
				}

				NavigationLink(value: Destination.Appearance) {
					SettingRow(title: "Appearence", systemImage: "paintpalette.fill", backgroundColor: .blue)
				}

				NavigationLink(value: Destination.AppLock) {
					SettingRow(title: "App Lock", systemImage: "lock.fill", backgroundColor: .red)
				}

			}

			/*Section {
				NavigationLink(value: Destination.ContentFilterView) {
					SettingRow(title: "Content Filters", systemImage: "shared.with.you.slash", backgroundColor: .green)
				}
			}*/

			Section {
				Link(destination: URL(string: AppConfig.shared.appUrl)!) {
					SettingRow(title: "Rate Us", systemImage: "star.fill", backgroundColor: .purple)
				}
				Link(destination: URL(string: "https://www.reddit.com/report")!) {
					SettingRow(title: "Report", systemImage: "exclamationmark.bubble.fill", backgroundColor: .red)
				}
				NavigationLink(value: Destination.TipView) {
					SettingRow(title: "Developer Tip Jar", systemImage: "archivebox.fill", backgroundColor: .gray)
				}
			}

			Section {
				NavigationLink(value: Destination.AboutView) {
					SettingRow(title: "About", systemImage: "info", backgroundColor: .blue)
				}
				Link(destination: URL(string: "https://www.websitepolicies.com/policies/view/ssKVyNi0")!) {
					SettingRow(title: "Terms & Privacy Policy", systemImage: "exclamationmark.shield.fill", backgroundColor: .cyan)
				}
			}
		}
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				trailingBarButtons
			}
		}
	}

	var trailingBarButtons: some View {
		NavigationLink(value: Destination.AccountList) {
			NavBarIcon(systemName: "person.2.fill")
		}
	}
}

struct SettingRow : View {
	let title: String
	let systemImage: String
	let backgroundColor: Color
	var body: some View {
		Label(title, systemImage: systemImage)
			.labelStyle(SettingsLabelStyle(backgroundColor: backgroundColor))
	}
}

struct SettingView_Previews: PreviewProvider {
	static var previews: some View {
		SettingView()
	}
}
