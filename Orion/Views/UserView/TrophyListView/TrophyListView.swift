//
//  TrophyListView.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import SwiftUI

struct TrophyListView: View {

	@StateObject var observed = Observed()
	let username: String

	var body: some View {
		VStack {
			if observed.isRunning {
				LoaderView().task { await observed.fetchTrophyData(username: username) }
			} else {
				if observed.trophies.count > 0 {
					List(observed.trophies) { trophy in
						HStack(alignment: .center, spacing: 15) {
							AsyncImageView(url: URL(string: trophy.icon70),
										   size: .init(width: 50, height: 50),
										   ratio: .fit)
							VStack(alignment: .leading, spacing: 2) {
								Text(trophy.name).font(.headline)
								Text(trophy.dateString).font(.footnote)
							}
						}
						.padding(.vertical, 10)
					}
				} else {
					Text(observed.errorMessage)
				}
			}

		}
		.navigationTitle("Trophies")
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct TrophyListView_Previews: PreviewProvider {
	static var previews: some View {
		TrophyListView(username: "")
	}
}
