//
//  RootView.swift
//  Orion
//
//  Created by Anil Solanki on 11/12/22.
//

import SwiftUI
import OSLog

struct RootView: View {

	@StateObject var observedUser = ObservedUser()
	@StateObject var alertManager = AlertManager()

	@EnvironmentObject var appSettings : AppSettings
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	@State var loading : Bool = true

	let oauth = Session.shared.auth
	let customLogger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "anil", category: "loginSession")

	var body: some View {
		if self.loading {
			LoadingView
		} else {
			AppTabbarView()
				.environmentObject(observedUser)
				.environmentObject(alertManager)
				.environment(\.managedObjectContext, observedUser.persistantContainer.viewContext)
				.fullScreenCover(isPresented: $observedUser.showSafariLoginWebView) {
					SafariWebViewController(url: self.oauth.challengeURL())
				}
				.onOpenURL { url in
					Task {
						await self.handleRedirect(url: url)
					}
				}
				.accentColor(Color.tintColors[tintOption])
				.alert(isPresented: $alertManager.isPresented) {
					switch alertManager.activeAlert {
					case .Login:
						let loginButton = Alert.Button.default(Text("Login"), action: observedUser.performLogin)
						return Alert(title: alertManager.titleText,
									 message: alertManager.messageText,
									 primaryButton: loginButton,
									 secondaryButton: alertManager.cancelButton)
					case .Info, .Error:
						return Alert(title: alertManager.titleText,
									 message: alertManager.messageText,
									 dismissButton: alertManager.secondaryButton)
					case .SubscribeAlert:
						let yesButton = Alert.Button.default(Text("Yes"), action: {
							self.actionJoinOrion(name: "t5_3mdtsj")
						})
						let laterButton = Alert.Button.default(Text("Later"))
						return Alert(title: alertManager.titleText,
									 message: alertManager.messageText,
									 primaryButton: yesButton,
									 secondaryButton: laterButton)
					}
				}
		}
	}

	var LoadingView : some View {
		LoaderView()
			.task {
				await self.observedUser.load()
				await MainActor.run { self.loading = false }
			}
	}

	private func handleRedirect(url: URL) async {
		customLogger.debug("handleRedirect \(url)")
		await MainActor.run {
			observedUser.showSafariLoginWebView = false
		}
		do {
			let code = try await self.oauth.getCode(from: url)
			customLogger.debug("code \(code)")
			let token = try await self.oauth.getToken(from: code)
			customLogger.debug("code \(token.accessToken ?? "notoken")")
			let user = try await self.oauth.getUser(for: token)
			customLogger.debug("user \(user.description ?? "failed user")")
			customLogger.debug("snoovatar \(user.snoovatar ?? "no-avatar")")
			customLogger.debug("icon \(user.icon ?? "no-icon")")
			customLogger.debug("totalKarma \(Int16(user.totalKarma ?? 0))")
			customLogger.debug("name \(user.name)")

			let appuser = AppUser(id: UUID(),
								  snoovatar_img: user.snoovatar,
								  icon_img: user.icon,
								  total_karma: Int16(user.totalKarma ?? 0),
								  name: user.name,
								  type: 0)

			customLogger.debug("User is created now ahead")

			if observedUser.doesExist(appuser) == false {
				try self.oauth.save(token, username: appuser.name)
				customLogger.debug("Saved token")
				try await observedUser.add(appuser)
				customLogger.debug("Saved user")
				UserDefaults.standard.set(appuser.name, forKey: .currentUserKey)
				UserDefaults.standard.synchronize()
				try await checkUserJoinedOrion()
			} else {
				customLogger.debug("UserAlreadyExist")
				throw UserLoginError.UserAlreadyExist
			}

		} catch UserLoginError.UserAlreadyExist {
			await MainActor.run {
				customLogger.debug("User Already Exists")
				alertManager.ErrorAlert(text: "User Already Exists")
			}
		} catch {
			await MainActor.run {
				customLogger.debug("Error")
				alertManager.ErrorAlert(text: error.localizedDescription)
			}
		}
	}

	public func checkUserJoinedOrion() async throws {
		let orion = try await SubredditService().get(subreddit: "r/orionapp")
		if let subscribed = orion.subscribed {
			if subscribed == false {
				await MainActor.run {
					alertManager.SubscribeAlert()
				}
			}
		}
	}
	private func actionJoinOrion(name: String) {
		Task {
			try? await SubredditService().joinSubreddit(name: name, status: true)
		}
	}

}

