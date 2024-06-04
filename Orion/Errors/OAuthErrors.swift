//
//  OAuthErrors.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

enum OAuthErrors : Error {
	case RefreshTokenMissing
	case InvalidCodeOrEmpty
	case InvalidState
	case InvalidScheme
}

extension OAuthErrors: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .RefreshTokenMissing:
			return "Refresh token in response is missing"
		case .InvalidCodeOrEmpty:
			return "Invalid OAuth Code or OAuth Code is Empty"
		case .InvalidScheme:
			return "Invalid OAuth Scheme"
		case .InvalidState:
			return "Invalid OAuth State"
		}
	}
}
