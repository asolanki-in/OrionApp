//
//  DecodingErrors.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

enum DecodingErrors : Error {
	case decodeFailed(String)
	case encodeFailed(String)
}

extension DecodingErrors: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .decodeFailed(let msg):
			return "Failed to decode: \(msg)"
		case .encodeFailed(let msg):
			return "Failed to endecode: \(msg)"
		}
	}
}
