//
//  Flairs.swift
//  OrionBeta
//
//  Created by Anil Solanki on 20/08/22.
//

import Foundation

// MARK: - Flair
// if e == emoji then user a and u
// if e == text then use t only
struct Flair: Codable, Hashable, Identifiable {
	let id = UUID()
	let a: String?
	let e: String
	let u: String?
	let t: String?
}
