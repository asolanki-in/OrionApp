//
//  AlertManager.swift
//  Orion
//
//  Created by Anil Solanki on 11/12/22.
//

import Foundation
import SwiftUI

enum ActiveAlert {
	case Login, Info, Error
	case SubscribeAlert
}

class AlertManager: ObservableObject {
	
	@Published var isPresented: Bool = false
	var activeAlert: ActiveAlert = .Info

	var titleText: Text = Text("")
	var messageText: Text?
	var primaryButton = Alert.Button.cancel(Text("Ok"))
	var secondaryButton = Alert.Button.cancel(Text("Dismiss"))
	var cancelButton = Alert.Button.cancel()

	public func LoginAlert() {
		self.titleText = Text("Login Required")
		self.messageText = Text("This action require login.")
		self.activeAlert = .Login
		self.isPresented = true
	}

	public func ErrorAlert(text: String) {
		self.titleText = Text("Error Occured")
		self.messageText = Text(text)
		self.activeAlert = .Error
		self.isPresented = true
	}

	public func SubscribeAlert() {
		self.titleText = Text("Want to Join r/OrionApp?")
		self.messageText = Text("r/OrionApp is official subreddit for this app. Join to get latest news of app, new feature, request & more.")
		self.activeAlert = .SubscribeAlert
		self.isPresented = true
	}
}
