//
//  EmptySearchView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct EmptySearchView: View {

	let text : String

    var body: some View {
		VStack(alignment: .center, spacing: 5) {
			Image(systemName: "text.magnifyingglass")
				.font(.system(size: 40))
				.fontWeight(.thin)
				.foregroundColor(.accentColor)
			Text(text)
				.fontWeight(.light)
				.multilineTextAlignment(.center)
		}
		.foregroundColor(.secondary)
		.padding(30)
    }
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView(text:"")
    }
}
