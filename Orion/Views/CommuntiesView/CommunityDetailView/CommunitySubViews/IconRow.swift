//
//  IconRow.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import SwiftUI

struct IconRow: View {

	let title: String
	let symbolName: String
	let color: Color

	var body: some View {
		HStack(spacing: 20) {
			Image(systemName: symbolName)
				.font(.system(size:20))
				.foregroundColor(color)
				.frame(width: 30, height: 30,  alignment: .center)
			Text(title)
		}
		.padding(.vertical, 2)
	}
}

struct IconRow_Previews: PreviewProvider {
    static var previews: some View {
		IconRow(title: "", symbolName: "", color: .red)
    }
}
