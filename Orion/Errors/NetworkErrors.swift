//
//  NetworkErrors.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

enum NetworkErrors : Error {
	case UnknownReponse(String)
	case NoResponse
	case Unauthorized
	case NoMoreData
	case Unavailable
}

extension NetworkErrors: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .UnknownReponse(let msg):
			return "Unknown Response: \(msg)"
		case .NoResponse:
			return "Unknown Response"
		case .Unauthorized:
			return "You are unauthorized"
		case .NoMoreData:
			return "No more data available"
		case .Unavailable:
			return "This content is Unavailable from Reddit"
		}
	}
}
