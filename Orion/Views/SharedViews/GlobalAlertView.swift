//
//  GlobalAlertView.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import SwiftUI

struct GlobalAlertView: Identifiable {
	var id = UUID().uuidString
	var title = Text("")
	var message: Text?
	var dismissButton: Alert.Button?
	var primaryButton: Alert.Button?
	var secondaryButton: Alert.Button?
}

enum GlobalAlertViewData {
	case Login
	case Join
	case alreadyExists

	var title : String {
		switch self {
		case .Login:
			return "You need to login to continue this action."
		case .Join:
			return "Do you want to join\nr/OrionApp subreddit?"
		case .alreadyExists:
			return "User already exist in app."
		}
	}

	var message : String {
		switch self {
		case .Login:
			return "Only Logged-in user are allowed to perform this action. Please login to continue."
		case .Join:
			return "By joining you will get all the updates about Orion app releases, bug and beta version. You can also review/request a new feature in our subreddit"
		case .alreadyExists:
			return "Please do not try to login with same user."
		}
	}
}
