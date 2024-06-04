//
//  String+Extension.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

extension String {
	static let currentUserKey = "current_user"
	static let anonymous = "34DB9E8C-AF30-4096-A700-645D978CD341"
}

extension String {
	var youtubeId: String? {
	  let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
	  let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
	  let range = NSRange(location: 0, length: count)
	  guard let result = regex?.firstMatch(in: self, range: range) else {
		return nil
	  }
	  return (self as NSString).substring(with: result.range)
	}


	func removeExtraSpaces() -> String {
	  return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
	}

}
