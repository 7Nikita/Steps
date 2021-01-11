//
//  ErrorFactory.swift
//  Stepper
//
//  Created by Nikita Pekurin on 6.01.21.
//

import Foundation

private let domain = "com.pnikita"

enum ErrorCode: Int {
    case noHKAccessProvided
}

public struct ErrorFactory {
    static func noHKAccesProvidedError() -> Error {
        let description = "No access to HealthKit provided."
        return createError(with: .noHKAccessProvided, for: description)
    }
}

private extension ErrorFactory {
    static func createError(with code: ErrorCode, for description: String?) -> Error {
        let userInfo = [NSLocalizedDescriptionKey: description ?? "No description provided."]
        return NSError(domain: domain, code: code.rawValue, userInfo: userInfo)
    }
}
