//
//  ScrollerRootView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 11/03/23.
//

import Foundation
import Combine

extension ScrollerRootView {
	final class Observed : ObservableObject {

		private var subscriptions = Set<AnyCancellable>()

		@Published var searchText = ""
		@Published var tempSubreddits = [Subreddit]()

		let service  = SearchService()

		init() {
			$searchText
				.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
				.sink(receiveValue: { [weak self] t in
					if (t.isEmpty == false) {
						self?.getSearchResults()
					}
				})
				.store(in: &subscriptions)
		}

		@MainActor
		private func completedSearch(subreddits: [Subreddit]?) {
			if let subreddits {
				self.tempSubreddits = subreddits
			} else {
				self.tempSubreddits.removeAll()
			}
		}

		private func getSearchResults() {
			Task.detached {
				do {
					let thing = try await self.service.searchSubreddits(query: self.searchText,
																		sort: Sort.searchstubs.first!,
																		after: nil)
					let temp = thing.data.children.map { thingSubreddit in
						return thingSubreddit.data
					}
					await self.completedSearch(subreddits: temp)
				} catch {
					await self.completedSearch(subreddits: nil)
				}
			}
		}
	}
}
