//
//  ScrollerView.swift
//  Orion
//
//  Created by Anil Solanki on 11/03/23.
//

import SwiftUI

struct ScrollerView: View {
	@State private var selection = "0"

	@State var items: [String] = ["0", "1", "2", "3"]

	var body: some View {
		TabView(selection: $selection) {
			ForEach(items, id: \.self) { item in
				Text(item)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.red)
					.tag(item)
			}
		}
		.rotationEffect(.degrees(90))
		.tabViewStyle(PageTabViewStyle())
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
		.onChange(of: selection, perform: { value in
			if Int(value) == (self.items.count - 1) {
				self.items.append("\(self.items.count)")
			}
		})
		.id(items)
	}
}


struct ScrollerView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollerView()
    }
}
