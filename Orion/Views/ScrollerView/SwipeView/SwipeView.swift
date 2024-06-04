//
//  SwipeView.swift
//  Orion
//
//  Created by Anil Solanki on 14/05/23.
//

import SwiftUI

struct SwipeView: View {

	let communityName: String
	@StateObject var observed = Observed()

    var body: some View {
		ScrollView {
			LazyHStack {
				ForEach(0...10000, id: \.self) { text in
					Text("\(text)")
				}
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.navigationTitle("Swipe")
		.toolbarBackground(.hidden, for: .tabBar)

    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
		SwipeView(communityName: "r/orion")
    }
}
