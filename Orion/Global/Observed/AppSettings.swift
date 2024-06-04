//
//  AppSettings.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation
import LocalAuthentication
import SwiftUI
import SimpleKeychain

class AppSettings : ObservableObject {

	init() {
		if self.isAppLockEnable {
			self.appLocked = true
		} else {
			self.appLocked = false
		}

		if let postDefault = UserDefaults.standard.data(forKey: "post_default_sort") {
			if let value = try? JSONDecoder().decode(Sort.self, from: postDefault) {
				self.postDefaultSort = value
			}
		}

		if let subDefault = UserDefaults.standard.data(forKey: "subreddit_default_sort") {
			if let value = try? JSONDecoder().decode(Sort.self, from: subDefault) {
				self.subredditDefaultSort = value
			}
		}

		if let commentDefault = UserDefaults.standard.data(forKey: "comments_default_sort") {
			if let value = try? JSONDecoder().decode(Sort.self, from: commentDefault) {
				self.commentDefaultSort = value
			}
		}

		if let searchDefault = UserDefaults.standard.data(forKey: "search_default_sort") {
			if let value = try? JSONDecoder().decode(Sort.self, from: searchDefault) {
				self.searchDefaultSort = value
			}
		}

		if let newsDefault = UserDefaults.standard.data(forKey: "news_default_sort") {
			if let value = try? JSONDecoder().decode(Sort.self, from: newsDefault) {
				self.newsDefaultSort = value
			}
		}
	}

	@Published var appLocked : Bool = false
	@Published var showBackgroundBlur : Bool = false
	@AppStorage("appColorScheme", store: .standard) var colorScheme : AppColorScheme = .System
	@AppStorage("app_lock_enable", store: .standard) var isAppLockEnable : Bool = false
	@AppStorage("enable_ads", store: .standard) var isAdsEnabled : Bool = false
	@AppStorage("safari_reader_mode", store: .standard) var isReaderModeEnable : Bool = false
	@Published var supporter : Bool = AppKeychainStore.getSupportStatus() {
		didSet {
			if supporter == true {
				AppKeychainStore.setSupporter()
			}
		}
	}

	@Published var postDefaultSort = Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot")  {
		didSet {
			let data = try? JSONEncoder().encode(postDefaultSort)
			UserDefaults.standard.set(data, forKey: "post_default_sort")
		}
	}

	@Published var subredditDefaultSort = Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot")  {
		didSet {
			let data = try? JSONEncoder().encode(subredditDefaultSort)
			UserDefaults.standard.set(data, forKey: "subreddit_default_sort")
		}
	}

	@Published var commentDefaultSort = Sort(title: "Best", children: nil, icon: "hand.thumbsup.fill", parent: nil, itemValue: "best")  {
		didSet {
			let data = try? JSONEncoder().encode(commentDefaultSort)
			UserDefaults.standard.set(data, forKey: "comments_default_sort")
		}
	}

	@Published var searchDefaultSort = Sort(title: "Best", children: nil, icon: "hand.thumbsup.fill", parent: nil, itemValue: "best")  {
		didSet {
			let data = try? JSONEncoder().encode(searchDefaultSort)
			UserDefaults.standard.set(data, forKey: "search_default_sort")
		}
	}

	@Published var newsDefaultSort = Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot")  {
		didSet {
			let data = try? JSONEncoder().encode(newsDefaultSort)
			UserDefaults.standard.set(data, forKey: "news_default_sort")
		}
	}
}

extension AppSettings {
	var bioMetricType : LABiometryType {
		var error: NSError?
		let laContext = LAContext()
		let isBimetricAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
		if isBimetricAvailable {
			return laContext.biometryType
		} else {
			return .none
		}
	}

	func unlockApplication() {
		let myContext = LAContext()
		let myLocalizedReasonString = "Orion Device Authentication"
		var authError: NSError?
		if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
			myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
				DispatchQueue.main.async {
					if success {
						self.appLocked = false
						print("Awesome!!... User authenticated successfully")
					} else {
						print("Sorry!!... User did not authenticate successfully")
					}
				}
			}
		} else {
			print("Sorry!!.. Could not evaluate policy.")
		}
	}
}

enum AppColorScheme : String, CaseIterable {
	case System = "Use System"
	case Dark = "Dark Mode"
	case Light = "Light Mode"

	public func envColorScheme() -> ColorScheme? {
		switch self {
		case .System:
			return nil
		case .Dark:
			return .dark
		case .Light:
			return .light
		}
	}
}

enum LinkOpenOption : String, CaseIterable {
	case inAppSafari = "In App Safari"
	case safari = "Safari"
}

enum SubredditLayoutOption : String, CaseIterable {
	case Card = "Card"
	case List = "Classic List"
}

enum UserPostLayoutOption : String, CaseIterable {
	case Card = "Card"
	case List = "Classic List"
}

//MARK: this holds userdefault keys
extension String {
	static let themeColorKey = "theme_color"
	static let autoDarkModeKey = "auto_dark_mode_enable"
	static let applyThemeOnSettingsKey = "enable_theme_settings"

	//settings
	static let generalLinkOptionKey = "general_link_option"
	static let readerModeEnableKey = "safari_reader_mode"
	static let postsSortKey = "post_sort_key"
	static let postsTimeKey = "post_time_sort_key"
	static let titleShareKey = "enable_title_share"
	static let autoPlayGifKey = "auto_play_gif"

	static let commentSortKey = "comment_sort_key"
	static let commentTimeKey = "comment_time_sort_key"

	static let touchEnabledKey = "touch_enabled"
	static let pasccodeEnabledKey = "passcode_enabled"
	static let blurEnabledKey = "blur_enabled"
	static let autoLockOptionKey = "auto_lock_time"

	static let loggedInUserKey = "any_user_logged_in"
	static let appLaunchedAlready = "app_launched_previously"

	static let appTintOption = "app_tint_option"

	static let postListLayout = "posts_list_layout"
	static let newsListLayout = "news_list_layout"

}



struct AppKeychainStore {

	static private let keychain = SimpleKeychain(service: AppConfig.shared.identifier)

	static public func getSupportStatus() -> Bool {
		if let status = try? keychain.string(forKey: "isSupporter"), status == "YES" {
			return true
		} else {
			return false
		}
	}

	static public func setSupporter() {
		try? keychain.set("YES", forKey: "isSupporter")
	}
}
