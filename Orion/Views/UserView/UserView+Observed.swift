//
//  UserView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import Foundation

extension UserView {

	final class Observed: ObservableObject {

		let service = UserDataService()

		@Published var user: User = .anonymous
		@Published var loading = true

		@MainActor private func completed(_ user: User?, _ error: Error?) {
			self.loading = false
			if let error {
				print(error)
			}
			if let user {
				self.user = user
			}
		}

		public func getProfile(name: String) {
			Task.detached(priority: .background) {
				await self.fetchProfileData(name)
			}
		}

		private func fetchProfileData(_ username: String) async {
			do {
				let thing = try await service.getUser(name: username)
				await self.completed(thing.data, nil)
			} catch {
				await self.completed(nil, error)
			}
		}
	}

}
