//
//  ViewModifiers.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI


extension View {
	func icon(with backgroundColor: Color) -> some View {
		modifier(Icon(with: backgroundColor))
	}
}

struct Icon: ViewModifier {
	var backgroundColor : Color = .gray

	init(with backgroundColor: Color) {
		self.backgroundColor = backgroundColor
	}

	func body(content: Content) -> some View {
		content
			.font(.system(size: 18))
			.foregroundColor(.white)
			.frame(width: 29, height: 29)
			.background(RoundedRectangle(cornerRadius: 6).foregroundColor(backgroundColor))
			.overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.tertiarySystemFill, lineWidth: 1))
	}
}
