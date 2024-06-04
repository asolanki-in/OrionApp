//
//  ContentFilterEntity+CoreDataProperties.swift
//  Orion
//
//  Created by Anil Solanki on 04/12/22.
//
//

import Foundation
import CoreData


extension ContentFilterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentFilterEntity> {
        return NSFetchRequest<ContentFilterEntity>(entityName: "ContentFilterEntity")
    }

	@nonobjc public class func fetchRequest(for type: Int) -> NSFetchRequest<ContentFilterEntity> {
		let request = ContentFilterEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "keyword", ascending: false)]
		request.predicate = NSPredicate(format: "type = %d", type as CVarArg)
		return request
	}

    @NSManaged public var id: UUID?
    @NSManaged public var type: Int16
    @NSManaged public var keyword: String?

}

extension ContentFilterEntity : Identifiable {

}
