//
//  CryptoKeychain.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

import Foundation

@propertyWrapper
public struct CryptoKeychain<T: Codable>: CryptoRepository {
    // MARK: Public Properties

    public var wrappedValue: T? {
        didSet {
            guard
                let wrappedValue = wrappedValue,
                let data = try? JSONEncoder().encode(SingleContainer(key: wrappedValue)),
                let encryptData = try? encryptData(data: data, with: salt) else {
                storage.removeObject(forKey: key)
                return
            }
            storage.set(encryptData, forKey: key)
        }
    }

    // MARK: Private Properties

    private let key: String
    private let storage: UserDefaults

    // MARK: Lifecycle

    public init(key: String) {
        let keychain = UserDefaults(suiteName: "")
        self.key = key
        storage = keychain ?? .standard

        guard
            let data = storage.data(forKey: key),
            let decryptData = try? decryptData(data: data, with: salt),
            let item = try? JSONDecoder().decode(SingleContainer<T>.self, from: decryptData)
        else {
            return
        }

        wrappedValue = item.key
    }

    public init<T: RawRepresentable>(_ key: T) where T.RawValue == String {
        self.init(key: key.rawValue)
    }
}

// MARK: - SingleContainer

struct SingleContainer<T: Codable>: Codable {
    let key: T
}
