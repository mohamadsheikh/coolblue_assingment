//
//  NetworkProduct.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

class NetworkProduct {
    
    let service : NetworkService
    
    init(service: NetworkService = NetworkService()) {
        self.service = service
    }
    
    private func fetchProducts(pageNumber: Int=1, searchTerm:String?=nil,completion: @escaping (Result<ProductListModel, Error>) -> Void) {
        
        var queryParameters : [URLQueryItem] = [URLQueryItem(name: "page", value: "\(pageNumber)")]
        
        if let searchTerm = searchTerm {
            queryParameters.append(URLQueryItem(name: "query", value: searchTerm))
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let client = NetworkClient(getClientWithURL: "https://bdk0sta2n0.execute-api.eu-west-1.amazonaws.com", path: "/mobile-assignment/search", queryParameters: queryParameters)
            
            self.service.makeRequest(withClient: client,dataType: ProductListModel.self,completion: completion)
        }
    }
    
    func getProducts(searchTerm: String?, completion: @escaping (Result<ProductListModel, Error>) -> Void) {
        fetchProducts(searchTerm: searchTerm, completion: completion)
    }
    
    func getProducts(searchTerm: String?,pageNumber: Int, completion: @escaping (Result<ProductListModel, Error>) -> Void) {
        fetchProducts(pageNumber: pageNumber,searchTerm: searchTerm ,completion: completion)
    }
}
