//
//  URL+Extension.swift
//  Orion
//
//  Created by Anil Solanki on 31/12/22.
//

import Foundation

enum URLContentType {
	case LINK
	case VIDEO
	case IMAGE
	case GIF
}


extension URL {
	func ofType() -> URLContentType {
		switch self.pathExtension {
		case "jpeg", "jpg", "png":
			return .IMAGE
		case "gif", "gifv", "webp":
			return .GIF
		case "webm", "mp4":
			return .VIDEO
		default:
			return .LINK
		}
	}
}
