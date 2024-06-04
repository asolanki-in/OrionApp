//
//  SearchViewModel.swift
//  Orion
//
//  Created by Anil Solanki on 20/11/22.
//

import Combine
import Foundation

final class SearchViewModel : ObservableObject {

	private var subscriptions = Set<AnyCancellable>()

	@Published var searchText = ""
	@Published var tempSubreddits = [Subreddit]()
	@Published var tempUsers = [User]()

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
	private func completedSearch(subreddits: [Subreddit], users: [User]) {
		self.emptyData()
		self.tempUsers = users
		self.tempSubreddits = subreddits
	}

	private func getSearchResults() {
		Task.detached {
			if let searchData = await self.autoSearchComplete() {
				var srs = [Subreddit]()
				var users = [User]()
				for data in searchData {
					switch data {
					case .subreddit(let subreddit):
						srs.append(subreddit)
					case .user(let user):
						users.append(user)
					default:
						print("no worries, search has something new")
					}
				}
				await self.completedSearch(subreddits: srs, users: users)
			}
		}
	}

	private func autoSearchComplete() async -> [SearchData]? {
		do {
			let thing = try await service.autoComplete(query: searchText)
			let templist = thing.data.children.map { $0 }
			return templist
		} catch {
			return nil
		}
	}

	public func emptyData() {
		self.tempSubreddits.removeAll()
		self.tempUsers.removeAll()
	}
}
