//
//  AppConfig.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

struct AppConfig {

	let version: String
	let build: String
	let identifier: String
	let developer: String
	let redirectURI: String
	let clientID: String
	let email: String

	static let shared = AppConfig()

	var userAgent: String {
		return "ios:" + identifier + ":v" + version + "(by /u/" + developer + ")"
	}

	var redirectURIScheme: String {
		if let scheme = URL(string: redirectURI)?.scheme {
			return scheme
		}
		return redirectURI
	}

	let appUrl = "https://apps.apple.com/app/orion-for-reddit/id1536533779"

	private init() {
		let dict = Bundle.main.infoDictionary
		version =  dict?["CFBundleShortVersionString"] as? String ?? "1.0"
		identifier = dict?["CFBundleIdentifier"] as? String ?? ""
		build = dict?["CFBundleVersion"] as? String ?? "1"
		redirectURI = "orionapp://login/redirect"
		email = ""
		developer = ""
		clientID = ""
	}

	var getBasic : String {
		let credential = self.clientID + ":"
		if let data = credential.data(using: .utf8) {
			let base64Str = data.base64EncodedString(options: .lineLength64Characters)
			return "Basic " + base64Str
		} else {
			return "Basic " + credential
		}
	}
}
