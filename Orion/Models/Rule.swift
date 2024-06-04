//
//  Rule.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import Foundation
import HTMLEntities

struct Rules : Decodable {
	var rules : [Rule]?
}

struct Rule : Decodable, Identifiable {
	let id = UUID().uuidString
	let description: String?
	let title: String

	enum CodingKeys: String, CodingKey {
		case description
		case title = "short_name"
	}

	var markdown: AttributedString? {
		if let mdtext = self.description?.htmlUnescape(), mdtext.isEmpty == false {
			do {
				let trimmedString = mdtext.trimmingCharacters(in: .whitespacesAndNewlines)
					.replacingOccurrences(of: "\\n{2,}", with: "\n\n", options: .regularExpression)
				return try AttributedString(markdown: trimmedString, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
			} catch {

			}
		}
		return nil
	}
}
