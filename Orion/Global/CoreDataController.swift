//
//  CoreDataController.swift
//  Orion
//
//  Created by Anil Solanki on 04/12/22.
//

import Foundation
import CoreData

class CoreDataController  {

	var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "OrionCoreData")
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				print("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	func saveContext() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				print("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
}


extension CoreDataController {

	public func getAnonymousEntity() -> UserEntity {
		let contentFilter = UserEntity(context: self.persistentContainer.viewContext)
		contentFilter.id = User.anonymous.id
		contentFilter.name = User.anonymous.name
		contentFilter.icon_img = User.anonymous.icon
		contentFilter.snoovatar_img = User.anonymous.snoovatar
		contentFilter.total_karma = Int16( 0)
		return contentFilter
	}

	public func getAllUsers() async -> [UserEntity]? {
		return await persistentContainer.viewContext.perform {
			return try? UserEntity.fetchRequest().execute()
		}
	}

	public func add(_ user : AppUser) async throws -> UserEntity {
		let entity = await persistentContainer.viewContext.perform {
			let contentFilter = UserEntity(context: self.persistentContainer.viewContext)
			contentFilter.id = UUID()
			contentFilter.name = user.name
			contentFilter.icon_img = user.icon_img
			contentFilter.snoovatar_img = user.snoovatar_img
			contentFilter.total_karma = user.total_karma
			return contentFilter
		}
		try persistentContainer.viewContext.save()
		return entity
	}

	public func delete(_ user : UserEntity) async {
		do {
			persistentContainer.viewContext.delete(user)
			try persistentContainer.viewContext.save()
			print("User Deleted From Store: " + user.name)
		} catch {
			print("Unresolved error \(error)")
		}
	}

	public func performUpdate() async {
		print("User Deleted From Store: ")
	}
}
