//
//  FullSearchUserView.swift
//  Orion
//
//  Created by Anil Solanki on 26/11/22.
//

import SwiftUI

struct FullSearchUserView: View {

	let query: String
	let service = SearchService()

	@State var paginator = Paginator(after: nil)
	@State var users = [UserSearchData]()

	@State var sortBy: Sort = Sort(title: "All Time", children: nil, icon: "infinity", parent: "Relevance", itemValue: "all")
	@State var presentFilter : Bool = false

	var body: some View {
		Group {
			if paginator.initialLoading {
				LoaderView().onAppear { self.getUsers()}
			} else {
				if users.count > 0 {
					List {
						Section(header: Text("Users")) {
							ForEach(users) { user in
								NavigationLink(value: Destination.User(user.name)) {
									UserSearchRow(user: user).task { getMore(item: user) }
								}
							}
						}
					}
				} else {
					tryAgainView
				}
			}
		}
		.navigationTitle("'\(query)'")
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: {
					self.presentFilter.toggle()
				}) {
					filterIcon()
				}
			}
		}
		.sheet(isPresented: $presentFilter) {
			FilterView(filterItem: $sortBy, stubs: Sort.searchstubs)
		}
		.onChange(of: sortBy) { [aSort = sortBy] newValue in
			filterChanged(oldValue: aSort, newValue: newValue)
		}
	}

	private func filterIcon() -> some View {
		switch sortBy.parent {
		case "Top":
			return Image(systemName: "chart.bar.xaxis").tint(.accentColor)
		case "Relevance":
			return Image(systemName: "circle.circle").tint(.accentColor)
		case "Comments":
			return Image(systemName: "text.bubble").tint(.accentColor)
		default:
			return Image(systemName: sortBy.icon).tint(.accentColor)
		}
	}

	var tryAgainView : some View {
		VStack(spacing: 5) {
			Text("No Data Found").font(.headline)
			Button(action: actionRefresh) {
				Label("Try Again", systemImage: "arrow.counterclockwise")
			}
			.buttonStyle(.borderless)
		}
	}
}

extension FullSearchUserView {
	private func filterChanged(oldValue: Sort, newValue: Sort) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			if oldValue.itemValue != newValue.itemValue {
				self.actionRefresh()
			} else if (oldValue.parent != nil) && (oldValue.parent != newValue.parent) {
				self.actionRefresh()
			}
		}
	}

	private func actionRefresh() {
		self.paginator = Paginator(after: nil)
		self.users.removeAll()
	}

	private func getUsers() {
		Task(priority: .userInitiated) {
			do {
				let thing = try await service.searchUsers(query: query, sort: sortBy, after: paginator.after)
				let temp = thing.data.children.map { thingUser in
					return thingUser.data
				}
				await self.serviceCompleted(more: temp, after: thing.data.after, error: nil)
			} catch {
				print(error)
				await self.serviceCompleted(more: nil, after: nil, error: error)
			}
		}
	}

	private func getMore(item: UserSearchData) {
		if paginator.loadingMore == true { return }
		if paginator.after == nil { return }
		if self.users.last?.id == item.id {
			paginator.loadingMore = true
			self.getUsers()
		}
	}

	@MainActor
	private func serviceCompleted(more: [UserSearchData]?, after: String?, error : Error?) {
		if let more { self.users.append(contentsOf: more) }
		paginator.initialLoading = false
		paginator.loadingMore = false
		paginator.after = after
	}

}
