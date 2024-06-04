//
//  OrionApp.swift
//  Orion
//
//  Created by Anil Solanki on 24/09/22.
//

import SwiftUI
import CoreData

@main
struct OrionApp: App {

	@StateObject var appSettings = AppSettings()
	@StateObject var router = Router()

	init() {

    }


	var body: some Scene {
		WindowGroup {
			if appSettings.appLocked {
				ApplicationLockView()
					.environmentObject(appSettings)
					.preferredColorScheme(appSettings.colorScheme.envColorScheme())
			} else {
				RootView()
					.environmentObject(appSettings)
					.environmentObject(router)
					.preferredColorScheme(appSettings.colorScheme.envColorScheme())
			}
		}
	}


	/*public func checkUserJoinedOrion() async throws {
	 let orion = try await SubredditService().get(subreddit: "r/orionapp")
	 if let subscribed = orion.subscribed {
	 if subscribed == false {
	 await MainActor.run {
	 self.authInProgress = false
	 self.alertInfo = GlobalAlertView(title: Text(GlobalAlertViewData.Join.title),
	 message: Text(GlobalAlertViewData.Join.message),
	 primaryButton: .default(Text("Yes"), action: {
	 self.actionJoinOrion(name: orion.name)
	 }),
	 secondaryButton: .default(Text("No")))
	 }
	 }
	 }
	 }
	 private func actionJoinOrion(name: String) {
	 Task {
	 try? await SubredditService().joinSubreddit(name: name, status: true)
	 }
	 }
	 
	 */
}

public extension UIApplication {
	func currentUIWindow() -> UIWindow? {
		let connectedScenes = UIApplication.shared.connectedScenes
			.filter { $0.activationState == .foregroundActive }
			.compactMap { $0 as? UIWindowScene }
		let window = connectedScenes.first?.windows.first { $0.isKeyWindow }
		return window
	}
}
