//
//  Color+Extension.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import SwiftUI

extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}

		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue:  Double(b) / 255,
			opacity: Double(a) / 255
		)
	}

	static var tintColors : [Color] {
		return [Color("tc_7"), Color("tc_1"), Color("tc_3"), Color("tc_2"), Color("tc_4"), Color("tc_5"), Color("tc_6"), Color("tc_8"), Color("tc_9"), Color("tc_10"), Color("tc_11"), Color("tc_12"), Color("tc_13"), Color("tc_14"), Color("tc_15"), Color("tc_16")]
	}

	static var randomColor : [Color] {
		return [.teal, .indigo, .purple, .green, .orange, .cyan, .yellow, .pink, .mint]
	}


	static var random: Color {
		return Color(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1)
		)
	}
}

extension Color {
	public static let systemGray 	= Color(UIColor.systemGray)
	public static let systemGray2 	= Color(UIColor.systemGray2)
	public static let systemGray3 	= Color(UIColor.systemGray3)
	public static let systemGray4 	= Color(UIColor.systemGray4)
	public static let systemGray5 	= Color(UIColor.systemGray5)
	public static let systemGray6 	= Color(UIColor.systemGray6)

	public static let label 			= Color(UIColor.label)
	public static let secondaryLabel 	= Color(UIColor.secondaryLabel)
	public static let tertiaryLabel 	= Color(UIColor.tertiaryLabel)
	public static let quaternaryLabel 	= Color(UIColor.quaternaryLabel)
	public static let link 				= Color(UIColor.link)
	public static let placeholderText 	= Color(UIColor.placeholderText)

	public static let separator 		= Color(UIColor.separator)
	public static let opaqueSeparator 	= Color(UIColor.opaqueSeparator)

	public static let systemBackground 			= Color(UIColor.systemBackground)
	public static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
	public static let tertiarySystemBackground 	= Color(UIColor.tertiarySystemBackground)


	// Adaptable grouped backgrounds
	public static let systemGroupedBackground 			= Color(UIColor.systemGroupedBackground)
	public static let secondarySystemGroupedBackground 	= Color(UIColor.secondarySystemGroupedBackground)
	public static let tertiarySystemGroupedBackground 	= Color(UIColor.tertiarySystemGroupedBackground)

	// Adaptable system fills
	public static let systemFill 			= Color(UIColor.systemFill)
	public static let secondarySystemFill 	= Color(UIColor.secondarySystemFill)
	public static let tertiarySystemFill 	= Color(UIColor.tertiarySystemFill)
	public static let quaternarySystemFill 	= Color(UIColor.quaternarySystemFill)

	public static let RowBackgroundColor 	= Color("RowBackground")

}
