//
//  VLabel.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct VLabel: View {

	let primary: String
	let secondary: String

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(primary).font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary)
			Text(secondary).font(.footnote).foregroundColor(.secondary)
		}
	}
}

struct VLabel_Previews: PreviewProvider {
    static var previews: some View {
        VLabel(primary: "", secondary: "")
    }
}
