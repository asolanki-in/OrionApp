//
//  SharedPostListView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct SharedPostListView: View {

	let listType: PostListType
	let service = PostService()

	@StateObject var observed = Observed()
	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var settings : AppSettings

	@State var sortBy: Sort = Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot")
	@State var presentFilter : Bool = false

	var body: some View {
		Group {
			if observed.paginator.initialLoading {
				LoaderView().task { observed.getPosts(type: listType, sort: settings.postDefaultSort) }
			} else {
				if observed.posts.count > 0 {
					cardPostList
				} else {
					tryAgainView
				}
			}
		}
		.navigationTitle(listType.displayName)
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
			FilterView(filterItem: $settings.postDefaultSort, stubs: Sort.postFilterStubData)
		}
		.onChange(of: settings.postDefaultSort) { [aSort = settings.postDefaultSort] newValue in
			filterChanged(oldValue: aSort, newValue: newValue)
		}
		/*.onReceive(observedUser.userUpdatePublisher) {
			self.observed.reset(listType, sortBy)
		}*/
	}

	var tryAgainView : some View {
		VStack(spacing: 5) {
			Text(observed.errorMessage)
				.font(.headline)
				.padding(.horizontal)
				.padding(.vertical, 5)
				.multilineTextAlignment(.center)
			Button(action: {
				self.observed.reset(listType, settings.postDefaultSort)
			}) {
				Label("Try Again", systemImage: "arrow.counterclockwise")
			}
			.buttonStyle(.borderless)
		}
	}

	var cardPostList : some View {
		List(observed.posts) { viewModel in
			ZStack {
				NavigationLink(value: Destination.PostDetail(viewModel)) { EmptyView()}
					.buttonStyle(PlainButtonStyle())
					.opacity(0)
				PostCardRowView(viewModel: viewModel)
			}
			.task { observed.getMore(viewModel, listType, settings.postDefaultSort)}
			.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
			.listRowSeparator(.hidden)
			.background(Color("RowBackground"))
		}
		.listStyle(PlainListStyle())
		.environment(\.defaultMinListRowHeight, 10)
	}

	private func filterIcon() -> some View {
		switch settings.postDefaultSort.parent {
		case "Top":
			return Image(systemName: "chart.bar.xaxis").tint(.accentColor)
		case "Controversial":
			return Image(systemName: "bubble.left.and.exclamationmark.bubble.right.fill").tint(.accentColor)
		default:
			return Image(systemName: settings.postDefaultSort.icon).tint(.accentColor)
		}
	}

	private func filterChanged(oldValue: Sort, newValue: Sort) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			if oldValue.itemValue != newValue.itemValue {
				self.observed.reset(listType, settings.postDefaultSort)
			} else if (oldValue.parent != nil) && (oldValue.parent != newValue.parent) {
				self.observed.reset(listType, settings.postDefaultSort)
			}
		}
	}
}

struct SharedPostListView_Previews: PreviewProvider {
	static var previews: some View {
		SharedPostListView(listType: .all)
	}
}
