//
//  CHelper.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation

struct CHelper {
	static func encode<T: Codable>(object: T) throws -> Data? {
		return try JSONEncoder().encode(object)
	}

	static func decode<T: Decodable>(_ data: Data, as clazz: T.Type) throws -> T? {
		return try JSONDecoder().decode(T.self, from: data)
	}
}
