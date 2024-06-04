//
//  PostSearchImageView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct PostSearchImageView: View {
	@State var presentFullScreenImage: Bool = false

	let LQURL: URL?
	let HQURL: URL?
	let size: CGSize

	var body: some View {
		SearchImageView(LQURL: LQURL, size: size, corner: 8)
			.onTapGesture {
				presentFullScreenImage.toggle()
			}
			.fullScreenCover(isPresented: $presentFullScreenImage) {
				FullScreenImageView(LQURL: LQURL, size: size, HQURL: HQURL)
			}
	}
}

struct SearchImageView: View {
	let LQURL: URL?
	let size: CGSize
	let corner: CGFloat

	var body: some View {
		AsyncImageView(url: LQURL, size: size, ratio: .fill)
			.cornerRadius(corner)
			.overlay(RoundedRectangle(cornerRadius: corner).stroke(Color(.systemGray5), lineWidth: 1))

	}
}


