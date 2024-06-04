//
//  UserLoginError.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

enum UserLoginError : Error {
	case UserAlreadyExist
}

extension UserLoginError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .UserAlreadyExist:
			return "User Already Exist."
		}
	}
}
