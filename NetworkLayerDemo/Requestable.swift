//
//  Requestable.swift
//  NetworkLayerDemo
//
//  Created by Itsuki on 2024/05/25.
//

import Foundation

enum RequestMethod: String {
    case get
    case post
    case put
    case delete
}



protocol Requestable {
    var scheme: String { get }

    var host: String? { get }
    var port: Int? { get }
    var user: String? { get }
    var password: String? { get }
    
    var path: String { get }
    
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryParams: [String: String]? { get } // Added for query parameters
    var pathParams: [String: String]? { get }  // Added for path parameters
    
}

extension Requestable {
    var scheme: String {
        return "https"
    }
    
    var host: String? {
        return "jsonplaceholder.typicode.com"
    }
    
    var port: Int? {
        return nil
    }

    var user: String? {
        return nil
    }
    var password: String? {
        return nil
    }
}

extension Requestable {
    func sendRequest<T>(responseType: T.Type) async throws -> T where T : Decodable {

        let request = try createRequest()
        print(request)

        var data: Data!
        var response: URLResponse!
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw ServiceError.timeout
        }
        
        guard let response = response as? HTTPURLResponse else { throw ServiceError.badRequest } //unknwonError
        let dataStirng = String(data: data, encoding: .utf8)
        print(dataStirng ?? "nothing")
        
        
        let statusCode = response.statusCode

        if !(200...300 ~= statusCode ) {
            throw ServiceError.badRequest
        }

        let decodedResponse = try decodeResponse(T.self, from: data)
        return decodedResponse

    }
    
    
    private func createRequest() throws -> URLRequest  {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.port = self.port
        urlComponents.user = self.user
        urlComponents.password = self.password
        urlComponents.path = self.path

        if let queryParams = self.queryParams {
            let queryItems = queryParams.map({URLQueryItem(name: $0.key, value: $0.value)})
            urlComponents.queryItems = queryItems
        }
        
        if let pathParams = self.pathParams {
            for param in pathParams {
                urlComponents.path.replace(param.key, with: param.value)
            }
        }

        guard let url = urlComponents.url else { throw ServiceError.urlCreation }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.header
        
        if let body = self.body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        }
        return request
    }
    
    private func decodeResponse<T>(_ type: T.Type, from data: Data) throws  -> T where T : Decodable {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch (let error) {
            print(error)
            throw ServiceError.parsing
        }

    }

}
