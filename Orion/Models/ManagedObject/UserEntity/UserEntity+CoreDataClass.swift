//
//  UserEntity+CoreDataClass.swift
//  Orion
//
//  Created by Anil Solanki on 04/12/22.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {
	func toAppUser() -> AppUser {
		return AppUser(id: self.id ?? UUID(),
					   snoovatar_img: self.snoovatar_img,
					   icon_img: self.icon_img,
					   total_karma: self.total_karma,
					   name: self.name,
					   type: self.type)
	}
}

struct AppUser : Decodable {
	var id: UUID
	var snoovatar_img: String?
	var icon_img: String?
	var total_karma: Int16 = Int16(0)
	var name: String
	var type: Int16


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
		if self.name == AppUser.anonymous.name {
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

	static func buildUUID() -> UUID {
		if let uuid = UUID(uuidString: "34DB9E8C-AF30-4096-A700-645D978CD341") {
			return uuid
		} else {
			return UUID()
		}
	}

	static let anonymous = AppUser(id: buildUUID(),
								   snoovatar_img: "https://i.redd.it/qaowx02uutx51.png",
								   icon_img: "",
								   total_karma: Int16(0),
								   name: "34DB9E8C-AF30-4096-A700-645D978CD341",
								   type: Int16(0))
}
