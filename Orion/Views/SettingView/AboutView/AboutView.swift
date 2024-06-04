//
//  AboutView.swift
//  Orion
//
//  Created by Anil Solanki on 24/12/22.
//

import SwiftUI
import MessageUI

struct AboutView: View {

	@State private var result: Result<MFMailComposeResult, Error>? = nil
	@State private var isShowingMailView = false
	@StateObject var logs = LogStore()
	@State private var exportShown = false
	@State private var showLoader = false

	var body: some View {
		List {
			Section {
				HStack(alignment: .center, spacing: 20) {
					Image("logo")
						.resizable()
						.frame(width: 50, height: 50, alignment: .center)
						.cornerRadius(10)
					VStack(alignment: .leading, spacing: 3) {
						Text("Orion for Reddit").font(.title3)
						Text("Version: \(AppConfig.shared.version) (\(AppConfig.shared.build))")
							.foregroundColor(.secondary)
					}
				}
			}

			Section {
				Button("Contact App Developer") {
					self.isShowingMailView.toggle()
				}

				NavigationLink(value: Destination.SubredditPage("r/orionapp")) {
					Text("Orion App Subreddit").foregroundColor(.accentColor)
				}
			}

			Section {
				if (showLoader) {
					Text("Generating Logs.....")
				} else {
					Button("Export Logs", action: actionLoader)
				}
			}
			.sheet(isPresented: $exportShown) {
				ActivityViewController(activityItems: [logs.entries.joined(separator: "\n")])
			}

			/*Section {
			 NavigationLink(destination: AknowledgementView()) {
			 Text("Acknowledgement")
			 }
			 }*/
		}
		.navigationTitle("About")
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(.visible, for: .navigationBar)
		.sheet(isPresented: $isShowingMailView) {
			MailView(result: $result) { composer in
				composer.setSubject("[Orion] Contact Developer")
				composer.setToRecipients(["anilsolanki.it@hotmail.com"])
			}
		}
	}

	private func actionLoader() {
		Task.detached {
			await MainActor.run {
				showLoader = true
			}
			await logs.export()
			await MainActor.run {
				showLoader = false
				exportShown = true
			}
		}
	}

}

struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
	}
}
