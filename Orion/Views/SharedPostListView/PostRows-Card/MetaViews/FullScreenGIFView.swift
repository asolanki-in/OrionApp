//
//  FullScreenGIFView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 17/09/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullScreenGIFView: View {

	@Environment(\.presentationMode) var presentationMode
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	let gifURL: URL?

	var body: some View {
		NavigationView {
			WebImage(url: gifURL)
				.onFailure { error in
					print(error)
				}
				.resizable()
				.indicator(.activity(style: .large))
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.toolbar {
					ToolbarItemGroup(placement: .navigationBarLeading) {
						Button("Done") {
							self.presentationMode.wrappedValue.dismiss()
						}
						.buttonStyle(.bordered)
					}
				}
				.navigationBarTitleDisplayMode(.inline)
				.navigationTitle("1 of 1")
				.toolbarBackground(.hidden, for: .navigationBar)
		}
		.tint(Color.tintColors[tintOption])
	}
}

struct FullScreenGIFView_Previews: PreviewProvider {
	static var previews: some View {
		FullScreenGIFView(gifURL: nil)
	}
}
