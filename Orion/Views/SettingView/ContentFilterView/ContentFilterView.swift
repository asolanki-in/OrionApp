//
//  ContentFilterView.swift
//  Orion
//
//  Created by Anil Solanki on 03/12/22.
//

import SwiftUI

struct ContentFilterView: View {

	@Environment(\.managedObjectContext) private var viewContext
	@State var activeSheet: ActiveSheet?

	enum ActiveSheet: Identifiable {
		case keyword, community, author
		var id: Int {
			hashValue
		}
	}

	@FetchRequest(fetchRequest: ContentFilterEntity.fetchRequest(for: 0))
	var postsContentFilter : FetchedResults<ContentFilterEntity>

	@FetchRequest(fetchRequest: ContentFilterEntity.fetchRequest(for: 1))
	var communityContentFilter : FetchedResults<ContentFilterEntity>

	@FetchRequest(fetchRequest: ContentFilterEntity.fetchRequest(for: 2))
	var authorContentFilter : FetchedResults<ContentFilterEntity>

	var body: some View {
		List {
			Section(header: Text("Hide posts using added keywords")) {
				Button(action: actionShowKeywordView) {
					HStack {
						Text("Add Keywords")
						Spacer()
						Text("\(postsContentFilter.count)")
					}
				}
				ForEach(postsContentFilter) { filter in
					Text(filter.keyword ?? "")
				}
			}

			Section(header: Text("Hide posts from added Communities")) {
				Button(action: actionShowCommunityKeywordView) {
					HStack {
						Text("Add Communities")
						Spacer()
						Text("\(communityContentFilter.count)")
					}
				}

				ForEach(communityContentFilter) { filter in
					Text(filter.keyword ?? "")
				}
			}

			Section(header: Text("Hide Posts Which created By Below Users")) {
				Button(action: actionShowAuthorKeywordView) {
					HStack {
						Text("Add Author")
						Spacer()
						Text("\(authorContentFilter.count)")
					}
				}
				ForEach(authorContentFilter) { filter in
					Text(filter.keyword ?? "")
				}
			}

			Section(footer:Text("Filters helps you remove content of specific Communities, Users or hide posts contains specific keywords.")) {}

		}
		.navigationTitle("Content Filters")
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(.visible, for: .navigationBar)
		.sheet(item: $activeSheet) { item in
			switch item {
			case .keyword:
				KeywordAddView(type: 0, contentFilter: $postsContentFilter)
			case .community:
				KeywordAddView(type: 1, contentFilter: $communityContentFilter)
			case .author:
				KeywordAddView(type: 2, contentFilter: $authorContentFilter)
			}
		}
	}

	private func actionShowKeywordView() {
		self.activeSheet = .keyword
	}

	private func actionShowCommunityKeywordView() {
		self.activeSheet = .community
	}

	private func actionShowAuthorKeywordView() {
		self.activeSheet = .author
	}
}
