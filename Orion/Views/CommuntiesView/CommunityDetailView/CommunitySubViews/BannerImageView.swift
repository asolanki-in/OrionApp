//
//  BannerImageView.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import SwiftUI
import CachedAsyncImage

struct BannerImageView: View {

	init(url:String, color: Color = .accentColor) {
		if url.isEmpty == false {
			self.bannerImage = URL(string: url)
		} else {
			self.bannerImage = nil
		}
		self.backgroundColor = color
	}

	let bannerImage: URL?
	let backgroundColor: Color
	var body: some View {
		Group {
			if (bannerImage != nil) {
				CachedAsyncImage(url: bannerImage) { phase in
					switch phase {
					case .success(let image):
						image.resizable().aspectRatio(contentMode: .fill)
					default:
						backgroundColor
					}
				}
				.frame(height: 60, alignment: .center)
			} else {
				backgroundColor.frame(height: 60, alignment: .center)
			}
		}
		.clipped()
	}
}

struct BannerImageView_Previews: PreviewProvider {
    static var previews: some View {
        BannerImageView(url: "")
    }
}
