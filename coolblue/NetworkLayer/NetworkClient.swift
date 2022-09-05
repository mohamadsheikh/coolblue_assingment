//
//  NetworkClient.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

class NetworkClient {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
    
    typealias HTTPHeader = [String:String]

    typealias JSON = [String: Any]
      
    let baseURL: String
    
    let path: String
    
    let method: HttpMethod
    
    let httpBody: Encodable?
    
    let headers: HTTPHeader?
    
    let queryParameters: [URLQueryItem]?
    
    let timeout: TimeInterval
    
    init(baseURL: String, path: String,method: HttpMethod,queryParameters: [URLQueryItem]?=nil,timeout: TimeInterval = NetworkConfigurations.defaultTimeout,headers:HTTPHeader?=nil,httpBody: Encodable?=nil) {
        self.baseURL = baseURL
        self.path = path
        self.timeout = timeout
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.httpBody = httpBody
    }
    
    convenience init(getClientWithURL baseURL: String, path: String,queryParameters: [URLQueryItem]?=nil,timeout: TimeInterval = NetworkConfigurations.defaultTimeout,headers: [String: String]?=nil) {
        self.init(baseURL:baseURL,path:path,method:.get,queryParameters:queryParameters,timeout: timeout, headers: headers, httpBody:nil)
    }
}

extension NetworkClient {
    var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = timeout
        
        if let httpBody = httpBody {
            request.httpBody = try? httpBody.jsonEncode()
        }
        
        return request
    }
}

private extension NetworkClient {
    var url: URL? {
        let urlComponents = URLComponents(string: baseURL)
        guard var components = urlComponents else {
            return URL(string: baseURL)
        }
        
        components.path = components.path.appending(path)
        
        guard let queryParams = queryParameters else {
            return components.url
        }
        
        if components.queryItems == nil {
            components.queryItems = []
        }
        
        components.queryItems?.append(contentsOf: queryParams)
        
        return components.url
    }
}

private extension Encodable {
    func jsonEncode() throws -> Data? {
        try JSONEncoder().encode(self)
    }
}

