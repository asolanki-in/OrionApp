//
//  UserStore.swift
//  Orion
//
//  Created by Anil Solanki on 04/12/22.
//

import Foundation
import CoreData
import Combine

final class UserStore {

	private let repository : CoreDataController
	var allUserEntity = [UserEntity]()

	init(container: CoreDataController) {
		self.repository = container
	}

	public func getAllUsers() async -> [UserEntity]? {
		if let users = await self.repository.getAllUsers() {
			self.allUserEntity = users
			return users;
		}
		return nil
	}

	var persistantContainer : NSPersistentContainer {
		return self.repository.persistentContainer
	}
}

extension UserStore {
	public func add(_ user: AppUser) async throws -> UserEntity {
		return try await self.repository.add(user)
	}

	public func delete(_ user: AppUser) async {
		if let index = self.allUserEntity.firstIndex(where: { $0.name == user.name }) {
			let entity = self.allUserEntity[index]
			self.allUserEntity.remove(at: index)
			await self.repository.delete(entity)
		}
	}

	public func edit(_ user: UserEntity) {
		Task(priority: .userInitiated) {

		}
	}

	public func switchUser(_ user: UserEntity) {

	}
}

extension UserStore {
	//	public func load() async {
	//		Task {
	//			self.users = await self.repository.getSavedUsers()
	//			if self.users?.count == 0 {
	//				let user = await self.repository.createAnonymousUser()
	//				self.users?.append(user)
	//				self.loginUser = user
	//			} else {
	//				self.loginUser = self.fetchCurrentUser()
	//			}
	//			if isAnonymous {
	//				self.session.updateSession(for: .anonymous)
	//			} else {
	//				self.session.updateSession(for: self.loginUser?.name ?? .anonymous)
	//			}
	//			print(self.loginUser?.name)
	//		}
	//	}
	//
	//	private func fetchCurrentUser() -> UserEntity? {
	//		if let activeName = UserDefaults.standard.string(forKey: .currentUserKey) {
	//			if let activeUser = self.users?.first(where: { $0.name == activeName }) {
	//				return activeUser
	//			}
	//		}
	//		return self.users?.first
	//	}
	//
	//	public func add(user: User) async throws {
	//		if let _ = self.users?.first(where: { $0.name == user.name }) {
	//			throw UserLoginError.UserAlreadyExist
	//		}
	//		let userEntity = await self.container.add(user)
	//		self.users?.append(userEntity)
	//		self.updateSession(for: userEntity)
	//	}
	//
	//	public func delete(user: UserEntity) {
	//
	//	}
	//
	//	public func updateSession(for entity: UserEntity) {
	//		if entity.id?.uuidString == self.loginUser?.id?.uuidString {
	//			return
	//		}
	//		if let uuidString = entity.id?.uuidString, uuidString == .anonymous {
	//			self.session.updateSession(for: uuidString)
	//		} else {
	//			self.session.updateSession(for: entity.name)
	//		}
	//		self.loginUser = entity
	//		UserDefaults.standard.set(entity.name, forKey: .currentUserKey)
	//		UserDefaults.standard.synchronize()
	//		DispatchQueue.main.async {
	//			self.userUpdatePublisher.send()
	//		}
	//	}
}
