//
//  CardRowImageView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct CardRowImageView: View {
	@State var presentFullScreenImage: Bool = false

	let LQURL: URL?
	let HQURL: URL?
	let size: CGSize

	var body: some View {
		PostAsycImageView(url: LQURL, size: size)
			.onTapGesture {
				presentFullScreenImage.toggle()
			}
			.fullScreenCover(isPresented: $presentFullScreenImage) {
				FullScreenImageView(LQURL: LQURL, size: size, HQURL: HQURL)
			}
	}
}
