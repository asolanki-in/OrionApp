//
//  SuspendView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct SuspendView: View {
	let title: String
    var body: some View {
		VStack(alignment: .center, spacing: 5) {
			Image(systemName: "person.2.slash.fill")
				.font(.system(size: 50))
				.foregroundColor(.accentColor)
			Text("Account of  ***\(title)***  is suspended on Reddit.").multilineTextAlignment(.center)
		}
		.padding(30)
    }
}

struct SuspendView_Previews: PreviewProvider {
    static var previews: some View {
        SuspendView(title: "asolanki26")
    }
}
