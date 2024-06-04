//
//  UserEntity+CoreDataProperties.swift
//  Orion
//
//  Created by Anil Solanki on 04/12/22.
//
//

import Foundation
import CoreData


extension UserEntity {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
		return NSFetchRequest<UserEntity>(entityName: "UserEntity")
	}

	@nonobjc public class func fetchRequest(for name: String) -> NSFetchRequest<UserEntity> {
		let request = UserEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
		request.predicate = NSPredicate(format: "name = %@", name as CVarArg)
		return request
	}

	@NSManaged public var id: UUID?
	@NSManaged public var snoovatar_img: String?
	@NSManaged public var icon_img: String?
	@NSManaged public var total_karma: Int16
	@NSManaged public var name: String
	@NSManaged public var type: Int16
}

extension UserEntity : Identifiable {

	var profileImage : URL? {
		if let primary = self.snoovatar_img, primary.isEmpty == false {
			return URL(string: primary.htmlUnescape())
		} else if let secondary = self.icon_img, secondary.isEmpty == false {
			return URL(string: secondary.htmlUnescape())
		} else {
			return URL(string: "https://i.redd.it/qaowx02uutx51.png")
		}
	}

	var isAnonymous : Bool {
		if self.name == User.anonymous.id.uuidString {
			return true
		}
		return false
	}

	var displayName : String {
		if self.isAnonymous {
			return "Anonymous"
		} else {
			return name
		}
	}
}
