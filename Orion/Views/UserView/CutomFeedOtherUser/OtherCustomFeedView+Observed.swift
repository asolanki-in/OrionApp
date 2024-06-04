//
//  OtherCustomFeedView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import Foundation

extension OtherCustomFeedView {
	final class Observed : ObservableObject {

		@Published private(set) var customFeeds = [CustomFeedViewModel]()
		@Published var requestRunning = true

		let service = UserDataService()
		var errorMessage = "No Content"

		public func fetchList(username: String) async {
			Task.detached(priority: .background) { [weak self] in
				do {
					let thing = try await self?.service.getCustomFeed(of: username)
					let items = thing?.map({ customFeed in
						CustomFeedViewModel(feed: customFeed.data)
					})
					await self?.completed(list: items, error: nil)
				} catch {
					await self?.completed(list: nil, error: nil)
				}
			}
		}

		@MainActor private func completed(list: [CustomFeedViewModel]?, error: Error?) {
			if let list {
				self.customFeeds = list
			}
			self.requestRunning = false
		}

	}
}
