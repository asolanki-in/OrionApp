//
//  ImageView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import CachedAsyncImage

struct ImageView: View {

	var url: URL?
	var size: CGSize
	var cornerRadius: CGFloat
	var contentMode : ContentMode = .fill

	var body: some View {
		CachedAsyncImage(url: url, transaction: Transaction(animation: .easeIn)) { phase in
			switch phase {
			case .success(let image):
				image.resizable()
			case .failure:
				Color(.systemGray4)
			case .empty:
				Color(.systemGray4)
			@unknown default:
				Color(.systemGray4)
			}
		}
		.aspectRatio(contentMode: contentMode)
		.frame(width: size.width, height: size.height, alignment: .center)
		.cornerRadius(cornerRadius)
		.overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color(.systemGray5), lineWidth: 1))
	}
}

extension ImageView {
	init(url: URL?, size: CGSize) {
		self.url = url
		self.size = size
		self.cornerRadius = 0
		self.contentMode = .fit
	}

	init(url: String, size: CGSize, contentMode: ContentMode) {
		self.url = URL(string: url)
		self.size = size
		self.cornerRadius = 0
		self.contentMode = contentMode
	}

	init(url: String, size: CGSize, cornerRadius: CGFloat, contentMode: ContentMode) {
		self.url = URL(string: url)
		self.size = size
		self.cornerRadius = cornerRadius
		self.contentMode = contentMode
	}
}

struct ImageView_Previews: PreviewProvider {
	static var previews: some View {
		ImageView(url: "", size: .zero, cornerRadius: 0, contentMode: .fit)
	}
}
