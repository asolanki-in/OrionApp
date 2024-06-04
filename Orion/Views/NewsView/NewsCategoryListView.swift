//
//  NewsCategoryListView.swift
//  Orion
//
//  Created by Anil Solanki on 19/11/22.
//

import SwiftUI

struct NewsCategoryListView: View {

	let service = NewsService()

	@State var categories = [CustomFeed]()
	@State var loading: Bool = true

	var body: some View {
		Group {
			if loading {
				LoaderView().onAppear { self.getNewsCategories() }
			} else {
				if categories.count > 0 {
					List(0..<categories.count, id: \.self) { index in
						NavigationLink(value: Destination.Custom(categories[index].path)) {
							NewsCategoryRow(title: categories[index].displayName,
											subtitle: categories[index].srnamesByComma,
											systemName: categories[index].descriptionMD,
											color: Color.randomColor[index])
						}
					}
					.refreshable {
						await getNewsCat()
					}
				} else {
					tryAgainView
				}
			}
		}
		.toolbarBackground(.visible, for: .navigationBar)
	}

	private func getNewsCat() async {
		do {
			let thing = try await service.getNewsCategories()
			let tempCategories = thing.map { thingPost in
				return thingPost.data
			}
			await self.serviceCompleted(cate: tempCategories, error: nil)
		} catch {
			await self.serviceCompleted(cate: nil, error: error)
		}
	}

	private func getNewsCategories() {
		Task(priority: .userInitiated) {
			do {
				let thing = try await service.getNewsCategories()
				let tempCategories = thing.map { thingPost in
					return thingPost.data
				}
				await self.serviceCompleted(cate: tempCategories, error: nil)
			} catch {
				await self.serviceCompleted(cate: nil, error: error)
			}
		}
	}

	@MainActor
	private func serviceCompleted(cate: [CustomFeed]?, error : Error?) {
		if let cate { self.categories = cate }
		loading = false
	}

	var tryAgainView : some View {
		VStack(spacing: 5) {
			Text("Something Went Wrong").font(.headline)
			Button(action: actionRefresh) {
				Label("Try Again", systemImage: "arrow.counterclockwise")
			}
			.buttonStyle(.borderless)
		}
	}

	private func actionRefresh() {
		self.categories.removeAll()
		self.loading = true
		self.getNewsCategories()
	}
}

struct NewsCategoryListView_Previews: PreviewProvider {
	static var previews: some View {
		NewsCategoryListView()
	}
}
