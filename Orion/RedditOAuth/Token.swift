//
//  Token.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

struct Token : Codable {
	var accessToken: String?
	var refreshToken: String?
	var tokenType: String?
	var expiresIn: Int?
	var expiresDate: TimeInterval?

	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case tokenType = "token_type"
		case expiresIn = "expires_in"
		case expiresDate = "expires_date"
		case refreshToken = "refresh_token"
	}

	var isValid : Bool {
		if let expiresDate = expiresDate {
			return Date(timeIntervalSince1970: expiresDate) > Date()
		} else {
			return false
		}
	}
}

extension Token {
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
		self.refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
		self.tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
		self.expiresIn = try values.decodeIfPresent(Int.self, forKey: .expiresIn)
		self.expiresDate = try values.decodeIfPresent(TimeInterval.self, forKey: .expiresDate)
		if self.expiresDate == nil {
			if let expireInSeconds = self.expiresIn {
				self.expiresDate = Date().timeIntervalSince1970 + TimeInterval(expireInSeconds)
			} else {
				self.expiresDate = Date().timeIntervalSince1970 + 3600.0
			}
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(accessToken, forKey: .accessToken)
		try container.encodeIfPresent(refreshToken, forKey: .refreshToken)
		try container.encodeIfPresent(tokenType, forKey: .tokenType)
		try container.encodeIfPresent(expiresIn, forKey: .expiresIn)
		try container.encodeIfPresent(expiresDate, forKey: .expiresDate)
	}
}
