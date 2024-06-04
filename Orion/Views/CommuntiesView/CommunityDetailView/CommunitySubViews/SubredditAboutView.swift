//
//  SubredditAboutView.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import SwiftUI

struct SubredditAboutView: View {

	let text: AttributedString?

	var body: some View {
		ScrollView {
			Text(text ?? "No Content")
				.padding()
				.navigationTitle("About")
		}
	}

	private func handleURLAction(url: URL) {
		let type = url.ofType()
		switch type {
		case .LINK:
			print("its a LINK \(url)")
		case .VIDEO:
			print("its a VIDEO \(url)")
		case .IMAGE:
			print("its a IMAGE \(url)")
		case .GIF:
			print("its a GIF \(url)")
		}
	}
}

struct SubredditAboutView_Previews: PreviewProvider {
	static var previews: some View {
		SubredditAboutView(text: "")
	}
}
