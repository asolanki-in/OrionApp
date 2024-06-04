//
//  PostAsycImageView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 31/07/22.
//

import SwiftUI
import CachedAsyncImage

struct PostAsycImageView: View {

	let url: URL?
	let size: CGSize

	var body: some View {
		VStack(alignment: .center, spacing: 0) {
			Divider()
			CachedAsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
				switch phase {
				case .success(let image):
					image.resizable().aspectRatio(contentMode: .fit)
				case .failure, .empty:
					Color(.systemGray5)
				@unknown default:
					Color(.systemGray5)
				}
			}
			.frame(width: size.width, height: size.height, alignment: .center)
			.background(Color(.systemGray5))
			Divider()
		}
	}
}

struct PostAsycImageView_Previews: PreviewProvider {
    static var previews: some View {
		PostAsycImageView(url: URL(string: ""), size: .zero)
    }
}


struct AsyncImageView : View {

	let url: URL?
	let size: CGSize
	let ratio: ContentMode

	var body: some View {
			CachedAsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
				switch phase {
				case .success(let image):
					image.resizable().aspectRatio(contentMode: ratio)
				case .failure, .empty:
					Color(.systemGray5)
				@unknown default:
					Color(.systemGray5)
				}
			}
			.frame(width: size.width, height: size.height, alignment: .center)
			.clipped()
	}
}
