//
//  FullScreenGalleryView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 07/08/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullScreenGalleryView: View {

	@Environment(\.presentationMode) var presentationMode
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	let size: CGSize
	let galleryMedia : [SingleMedia]
	@State var navTitle: String = ""

	@State private var currentTab : Int = 0

	var body: some View {
		NavigationView {
			TabView(selection: $currentTab) {
				ForEach(galleryMedia.indices, id:\.self) { index in
					let media = galleryMedia[index]
					VStack {
						if let u = media.u {
							WebImage(url: URL(string: u))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
							if let caption = media.caption?.trimmingCharacters(in: .whitespacesAndNewlines) {
								Text(caption)
									.font(.footnote)
									.multilineTextAlignment(.leading)
									.frame(maxWidth: .infinity)
									.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
									.background(.ultraThinMaterial)
							}
						} else if let gif = media.gif {
							WebImage(url: URL(string: gif))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
							if let caption = media.caption?.trimmingCharacters(in: .whitespacesAndNewlines) {
								Text(caption)
									.font(.footnote)
									.multilineTextAlignment(.leading)
									.frame(maxWidth: .infinity)
									.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
									.background(.ultraThinMaterial)
							}
						} else {
							EmptyView()
						}
					}
					.tag(index)
				}
			}
			.onChange(of: currentTab) { newValue in
				self.navTitle = "\(newValue + 1) of \(galleryMedia.count)"
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.onAppear {
				self.navTitle = "1 of \(galleryMedia.count)"
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarLeading) {
					Button("Done") {
						self.presentationMode.wrappedValue.dismiss()
					}
					.buttonStyle(.bordered)
				}
			}
			.toolbarBackground(.hidden, for: .navigationBar)
			.navigationTitle(self.navTitle)
			.navigationBarTitleDisplayMode(.inline)
		}
		.tint(Color.tintColors[tintOption])
	}
}

//struct FullScreenGalleryView_Previews: PreviewProvider {
//    static var previews: some View {
//        FullScreenGalleryView()
//    }
//}
