//
//  TokenStoreError.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

enum TokenStoreError : Error {
	case InvalidName
	case TokenIsEmpty
	case TokenSaveFailed
}

extension TokenStoreError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .InvalidName:
			return "Name is Invalid"
		case .TokenIsEmpty:
			return "Token is empty"
		case .TokenSaveFailed:
			return "Saving Token in Keychain failed"
		}
	}
}
