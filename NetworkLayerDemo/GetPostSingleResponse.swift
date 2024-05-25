//
//  GetPostSingleResponse.swift
//  NetworkLayerDemo
//
//  Created by Itsuki on 2024/05/25.
//

import Foundation

struct GetPostSingleResponse: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

