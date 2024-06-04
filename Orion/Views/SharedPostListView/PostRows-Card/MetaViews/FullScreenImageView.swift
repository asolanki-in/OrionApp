//
//  FullScreenImageView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 07/08/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullScreenImageView: View {

	@Environment(\.presentationMode) var presentationMode
	@State var presentDownloadAlert = false
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	let LQURL: URL?
	let size: CGSize
	let HQURL: URL?
	@StateObject var imageManager = ImageManager()

	@State var scale: CGFloat = 1
	@State var scaleAnchor: UnitPoint = .center
	@State var lastScale: CGFloat = 1
	@State var offset: CGSize = .zero
	@State var lastOffset: CGSize = .zero

	var body: some View {
		NavigationView {
			GeometryReader { geometry in
				let magnificationGesture = MagnificationGesture()
					.onChanged{ gesture in
						scaleAnchor = .center
						scale = lastScale * gesture
					}
					.onEnded { _ in
						fixOffsetAndScale(geometry: geometry)
					}

				let dragGesture = DragGesture()
					.onChanged { gesture in
						var newOffset = lastOffset
						newOffset.width += gesture.translation.width
						newOffset.height += gesture.translation.height
						offset = newOffset
					}
					.onEnded { _ in
						fixOffsetAndScale(geometry: geometry)
					}

				Group {
					if let image = imageManager.image {
						Image(uiImage: image)
							.resizable()
					} else {
						WebImage(url: LQURL)
							.resizable()
					}
				}
				.scaledToFit()
				.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
				.scaleEffect(scale, anchor: scaleAnchor)
				.offset(offset)
				.gesture(dragGesture)
				.gesture(magnificationGesture)
				.onTapGesture(count: 2) {
					if self.scale > 1 {
						withAnimation {
							self.scale = 1
						}
					} else {
						withAnimation {
							self.scale = 2
						}
					}
					fixOffsetAndScale(geometry: geometry)
				}
			}
			.edgesIgnoringSafeArea(.all)
			.onAppear {
				self.imageManager.load(url: HQURL)
			}
			.onDisappear { self.imageManager.cancel() }
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarLeading) {
					Button("Done") {
						self.presentationMode.wrappedValue.dismiss()
					}
					.buttonStyle(.bordered)
				}

				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Button {
						if let image = self.imageManager.image {
							UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
						}
					} label: {
						Image(systemName: "square.and.arrow.down.fill")
					}
					.buttonStyle(.bordered)
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle("1 of 1")
			.toolbarBackground(.hidden, for: .navigationBar)
			.edgesIgnoringSafeArea([.leading, .trailing, .bottom])

		}
		.tint(Color.tintColors[tintOption])
		.environment(\.colorScheme,  .dark)
	}

	private func fixOffsetAndScale(geometry: GeometryProxy) {
		let newScale: CGFloat = .minimum(.maximum(scale, 1), 4)
		let screenSize = geometry.size

		let originalScale = size.width / size.height >= screenSize.width / screenSize.height ?
		geometry.size.width / size.width :
		geometry.size.height / size.height

		let imageWidth = (size.width * originalScale) * newScale

		var width: CGFloat = .zero
		if imageWidth > screenSize.width {
			let widthLimit: CGFloat = imageWidth > screenSize.width ?
			(imageWidth - screenSize.width) / 2
			: 0

			width = offset.width > 0 ?
				.minimum(widthLimit, offset.width) :
				.maximum(-widthLimit, offset.width)
		}

		let imageHeight = (size.height * originalScale) * newScale
		var height: CGFloat = .zero
		if imageHeight > screenSize.height {
			let heightLimit: CGFloat = imageHeight > screenSize.height ?
			(imageHeight - screenSize.height) / 2
			: 0

			height = offset.height > 0 ?
				.minimum(heightLimit, offset.height) :
				.maximum(-heightLimit, offset.height)
		}

		let newOffset = CGSize(width: width, height: height)
		lastScale = newScale
		lastOffset = newOffset
		withAnimation() {
			offset = newOffset
			scale = newScale
		}
	}

}

struct FullScreenImageView_Previews: PreviewProvider {
	static var previews: some View {
		FullScreenImageView(LQURL: URL(string: ""), size: CGSize.zero, HQURL: nil)
	}
}
