//
//  ThingModel.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

typealias ThingList<T:Decodable> = Thing<ThingData<Thing<T>>>

struct Thing<T:Decodable> : Decodable {
	let kind : String
	var data : T
}

struct ThingData<T:Decodable> : Decodable {
	let after : String?
	var children : [T]
}

struct Listing<T: Decodable> : Decodable {
	let after: String
	let children: [Thing<T>]
}

struct AnyCodable : Decodable {
	let message : String?
	let error : Int?
}
