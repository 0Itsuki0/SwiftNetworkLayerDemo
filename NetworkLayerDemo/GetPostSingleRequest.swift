//
//  GetPostSingle.swift
//  NetworkLayerDemo
//
//  Created by Itsuki on 2024/05/25.
//

import Foundation

struct GetPostSingleRequest: Requestable {
    
    var path: String = "/posts/:id"
    
    var method: RequestMethod = .get
    
    var header: [String : String]? = nil
    
    var body: [String : String]? = nil
    
    var queryParams: [String : String]? = nil
    
    var pathParams: [String : String]? = nil

    init(id: String) {
        self.pathParams = [":id": id]
    }
        
}
