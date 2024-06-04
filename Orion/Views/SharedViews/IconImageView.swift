//
//  IconImageView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import CachedAsyncImage

struct IconImageView: View {

	var url: URL?
	var size: CGSize

	var body: some View {
		CachedAsyncImage(url: url) { phase in
			switch phase {
			case .success(let image):
				image.resizable()
			case .failure, .empty:
				Color(.systemGray6)
			@unknown default:
				Color(.systemGray6)
			}
		}
		.aspectRatio(contentMode: .fit)
		.frame(width: size.width, height: size.height, alignment: .center)
		.clipped()
	}
}

extension IconImageView {
	init(url: String, size: CGSize) {
		self.url = URL(string: url)
		self.size = size
	}
}

struct IconImageView_Previews: PreviewProvider {
    static var previews: some View {
		IconImageView(url: "", size: .zero)
    }
}
