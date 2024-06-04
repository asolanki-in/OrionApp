//
//  MyLinkRow.swift
//  Orion
//
//  Created by Anil Solanki on 24/09/22.
//

import SwiftUI

struct MyLinkRow: View {

	let title: String
	let symbolName: String
	let color: Color

	var body: some View {
		HStack(spacing: 20) {
			Image(systemName: symbolName)
				.font(.system(size:22))
				.foregroundColor(color)
				.frame(width: 30, height: 30,  alignment: .center)
			Text(title).font(.body)
		}
		.padding(.vertical, 4)
	}
}

struct MyLinkRow_Previews: PreviewProvider {
	static var previews: some View {
		List {
			MyLinkRow(title: "Home", symbolName: "rectangle.and.hand.point.up.left.filled", color: .secondary)
			MyLinkRow(title: "Home", symbolName: "rectangle.and.hand.point.up.left.filled", color: .secondary)
		}
	}
}
