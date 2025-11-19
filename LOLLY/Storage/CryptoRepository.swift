//
//  CryptoRepository.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

import CryptoSwift
import Foundation

protocol CryptoRepository {
    var salt: String { get }
    func encrypt(string: String, with salt: String) throws -> Data
    func encryptData(data: Data?, with salt: String) throws -> Data
    func decrypt(data: Data, with salt: String) throws -> String
    func decryptData(data: Data, with salt: String) throws -> Data
    func md5(_ string: String) -> String
}

extension CryptoRepository {
    var salt: String {
        ([String.self, Int.self] as [Any]).description
    }

    func encrypt(string: String, with salt: String) throws -> Data {
        let algh = try Blowfish(
            key: SHA3(variant: .keccak256).calculate(for: salt.bytes),
            padding: .pkcs7
        )
        let encryptData = try algh.encrypt(string.bytes)
        return Data(encryptData)
    }

    func encryptData(data: Data?, with salt: String) throws -> Data {
        let hexString = data?.toHexString() ?? ""
        return try encrypt(string: hexString, with: salt)
    }

    func decrypt(data: Data, with salt: String) throws -> String {
        let algh: Blowfish = try Blowfish(
            key: SHA3(variant: .keccak256).calculate(for: salt.bytes),
            padding: .pkcs7
        )
        let decryptedData: [UInt8] = try algh.decrypt(data.bytes)

        guard let userData = String(bytes: decryptedData, encoding: .ascii) else {
            throw CryptoError.notDecrypt
        }

        return userData
    }

    func decryptData(data: Data, with salt: String) throws -> Data {
        let encryptHexStr = try decrypt(data: data, with: salt)
        return Data(hex: encryptHexStr)
    }

    func md5(_ string: String) -> String {
        return string.md5()
    }
}

private enum CryptoError: Error {
    case notDecrypt
    case notEncrypt
}

fileprivate extension String {
    var bytes: [UInt8] {
        data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
    }
}

fileprivate extension Data {
    var bytes: [UInt8] {
        Array(self)
    }
}
