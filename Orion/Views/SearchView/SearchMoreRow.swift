//
//  SearchMoreRow.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct SearchMoreRow: View {

	enum SearchMoreType {
		case sr
		case usr
		case pst
	}

	let query: String
	let searchtype: SearchMoreType

	var body: some View {
		HStack(alignment: .center, spacing: 15) {
			Image(systemName: "list.bullet")
			switch searchtype {
			case .sr:
				Text("More Communities for **'\(query)'**")
			case .usr:
				Text("More Users for **'\(query)'**")
			case .pst:
				Text("Load Posts for **'\(query)'**")
			}
		}
		.foregroundColor(.accentColor)
		.font(.subheadline)
	}
}

struct SearchMoreRow_Previews: PreviewProvider {
    static var previews: some View {
		SearchMoreRow(query: "More", searchtype: .sr)
    }
}
