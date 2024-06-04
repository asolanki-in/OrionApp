//
//  TrophyListView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import Foundation

extension TrophyListView {
	final class Observed : ObservableObject {

		@Published private(set) var trophies = [Trophy]()
		@Published var isRunning = true

		let service = UserDataService()
		var errorMessage: String = "No Trophies"

		func fetchTrophyData(username: String) async {
			Task.detached(priority: .background) { [weak self] in
				do {
					let thing = try await self?.service.getTrophies(username: username)
					let items = thing?.data.trophies.map { $0.data }
					await self?.completed(with: items, nil)
				} catch {
					await self?.completed(with: [], error)
				}
			}
		}

		@MainActor private func completed(with trophies: [Trophy]? , _ error: Error?) {
			if let apiError = error {
				self.errorMessage = apiError.localizedDescription
			} else {
				self.trophies = trophies ?? []
			}
			self.isRunning = false
		}

	}

}
