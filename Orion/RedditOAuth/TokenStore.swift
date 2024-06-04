//
//  TokenStore.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import Foundation
import SimpleKeychain

struct TokenStore {

	private let keychain = SimpleKeychain(service: AppConfig.shared.identifier)

	public func getToken(of name: String) throws -> Token {
		let data = try keychain.data(forKey: name)
		if let token = try CHelper.decode(data, as: Token.self) {
			return token
		} else {
			throw TokenStoreError.TokenIsEmpty
		}
	}

	public func save(token: Token, for name: String) throws {
		if name.isEmpty { throw TokenStoreError.InvalidName}
		if let data = try CHelper.encode(object: token) {
			try keychain.set(data, forKey: name)
		} else {
			throw TokenStoreError.TokenSaveFailed
		}
	}

	public func removeToken(of name: String) throws {
		if name.isEmpty { throw TokenStoreError.InvalidName }
		try keychain.deleteItem(forKey: name)
	}
}
