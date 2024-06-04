//
//  ObservedUser.swift
//  Orion
//
//  Created by Anil Solanki on 11/12/22.
//

import Foundation
import CoreData

final class ObservedUser : ObservableObject {

	let store = UserStore(container: CoreDataController())

	var persistantContainer : NSPersistentContainer {
		return self.store.persistantContainer
	}

	@Published var showSafariLoginWebView = false
	@Published var allUsers = [AppUser]()
	@Published var loggedInUser = AppUser.anonymous

	@MainActor
	private func addLocal(_ user: AppUser) {
		Session.shared.updateSession(for: user.name)
		self.allUsers.append(user)
		self.loggedInUser = user
	}

	@MainActor
	private func deleteUser(user: AppUser) {
		self.allUsers.removeAll(where: { $0.name == user.name })
	}

	public func load() async {
		if let users = await self.store.getAllUsers() {
			await MainActor.run {
				for user in users {
					self.allUsers.append(user.toAppUser())
				}
			}
		}
		/*
		 * No Users present in core data
		 * Create Anonymous user and add it core data
		 */
		var current: AppUser?

		if self.allUsers.count == 0 {
			do {
				let entity = try await self.createAnonymous()
				current = entity.toAppUser()
			} catch {
				print(error.localizedDescription)
				current = self.currentUser()
			}
		} else {
			current = self.currentUser()
		}

		if let current {
			await MainActor.run {
				self.loggedInUser = current
				Session.shared.updateSession(for: current.name)
			}
		}
		print("Logged In User: \(self.loggedInUser.displayName)")
	}


	public func performLogin() {
		Session.shared.auth.state = UUID().uuidString
		self.showSafariLoginWebView.toggle()
	}
}

extension ObservedUser {
	public func createAnonymous() async throws -> UserEntity {
		let entity = try await self.store.add(.anonymous)
		await self.addLocal(entity.toAppUser())
		return entity
	}

	public func doesExist(_ user: AppUser) -> Bool {
		if let _ = self.allUsers.first(where: {$0.name == user.name}) {
			return true
		}
		return false
	}

	public func add(_ user: AppUser) async throws {
		let entity = try await self.store.add(user)
		await self.addLocal(entity.toAppUser())
	}

	public func delete(_ username: String) {
		Task(priority: .userInitiated) {
			if let user = self.allUsers.first(where: { $0.name == username }) {
				await self.store.delete(user)
				await self.deleteUser(user: user)
				if let anonyuser = self.getAnonymous() {
					self.switchUser(anonyuser)
				} else {
					self.switchUser(AppUser.anonymous)
				}
			}
		}
	}

	public func edit(_ user: UserEntity) {

	}

	public func switchUser(_ user: AppUser) {
		Task {
			Session.shared.updateSession(for: user.name)
			UserDefaults.standard.set(user.name, forKey: .currentUserKey)
			UserDefaults.standard.synchronize()
			await MainActor.run {
				self.loggedInUser = user
			}
		}
	}

	private func currentUser() -> AppUser? {
		if let activeName = UserDefaults.standard.string(forKey: .currentUserKey) {
			if let activeUser = self.allUsers.first(where: { $0.name == activeName }) {
				return activeUser
			}
		}
		return self.allUsers.first
	}

	private func getAnonymous() -> AppUser? {
		if let anonymous = self.allUsers.first(where: { $0.name == AppUser.anonymous.name }) {
			return anonymous
		}
		return self.allUsers.first
	}
}
