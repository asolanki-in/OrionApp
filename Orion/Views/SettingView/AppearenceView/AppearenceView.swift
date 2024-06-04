//
//  AppearenceView.swift
//  Orion
//
//  Created by Anil Solanki on 15/10/22.
//

import SwiftUI

struct AppearenceView: View {

	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0
	@AppStorage(.postListLayout, store: .standard) var listRowLayout : PostListLayoutOption = .Card
	@AppStorage(.newsListLayout, store: .standard) var newsListRowLayout : NewsViewLayoutOption = .Card

	@State private var customColor: Color = .blue

	@EnvironmentObject var settings : AppSettings


	let tintColors = Color.tintColors
	let lastIndex = Color.tintColors.count - 1

	var body: some View {
		List {

			/*Section(header: Text("Layout Options")) {
				Picker("Posts", selection: $listRowLayout) {
					ForEach(PostListLayoutOption.allCases, id: \.self) { option in
						Text(option.rawValue)
					}
				}

				Picker("News", selection: $newsListRowLayout) {
					ForEach(NewsViewLayoutOption.allCases, id: \.self) { option in
						Text(option.rawValue)
					}
				}
			}*/

			Section(header: Text("App Color Scheme")) {
				Picker("Mode", selection: $settings.colorScheme) {
					ForEach(AppColorScheme.allCases, id: \.self) { option in
						Text(option.rawValue)
					}
				}
			}

			Section(header: Text("App Tint Color")) {
				ScrollView(.horizontal, showsIndicators: false) {
					Grid {
						GridRow {
							ForEach(tintColors.indices, id: \.self) { index in
								Button(action:{
									withAnimation {
										self.tintOption = index
									}
								}) {
									switch index {
									case 0:
										circleView(index: index).padding(.leading, 20)
									case lastIndex:
										circleView(index: index).padding(.trailing, 20)
									default:
										circleView(index: index)
									}
								}
							}
						}
					}
				}
				.listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))

				//ColorPicker("Custom tint color", selection: $customColor)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Appearence")
		.toolbarBackground(.visible, for: .navigationBar)
	}


	private func circleView(index: Int) -> some View {
		if tintOption == index {
			return AnyView(ZStack {
				Circle().foregroundColor(tintColors[index])
					.frame(width: 60, height: 60)
				Circle().strokeBorder(Color.white,lineWidth: 6).foregroundColor(.clear)
					.frame(width: 40, height: 40)
			})
		} else {
			return AnyView(Circle().foregroundColor(tintColors[index]).frame(width: 60, height: 60))
		}
	}
}

struct AppearenceView_Previews: PreviewProvider {
	static var previews: some View {
		AppearenceView()
	}
}
