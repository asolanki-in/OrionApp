//
//  FilterView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 13/08/22.
//

import SwiftUI

struct FilterView: View {

	@Binding var filterItem : Sort
	@Environment(\.presentationMode) var presentationMode
	let stubs : [Sort]
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	var body: some View {
		NavigationView {
			List(stubs, children: \.children) { item in
				if let child = item.children, child.count > 0 {
					Label(item.title, systemImage: item.icon).padding(.vertical, 8)
				} else {
					Button(action: {
						self.filterSelection(item: item)
					}) {
						Label(item.title, systemImage: item.icon).padding(.vertical, 8)
					}
				}
			}
			.foregroundColor(.primary)
			.font(.headline)
			.navigationTitle(navigationTitle)
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: actionCancel) {
						Text("Cancel").fontWeight(.bold)
					}
				}
			}
		}
		.presentationDetents([.medium, .large])
		.tint(Color.tintColors[tintOption])
	}

	var navigationTitle: String {
		if let parent = filterItem.parent {
		  return "\(parent) \(filterItem.title)"
		} else {
		  return filterItem.title
		}
	}

	func filterSelection(item: Sort) {
		self.filterItem = item
		presentationMode.wrappedValue.dismiss()
	}

	func actionCancel() {
		presentationMode.wrappedValue.dismiss()
	}
}
