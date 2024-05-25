//
//  ServiceError.swift
//  NetworkLayerDemo
//
//  Created by Itsuki on 2024/05/25.
//

import Foundation

enum ServiceError: Error {
    case urlCreation
    case timeout
    case parsing
    case badRequest
}
