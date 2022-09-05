//
//  NetworkProductMock.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

class NetworkProductMock : NetworkProduct {
    
    let productListMock : ProductListModel
    var getProductCalled = false
    
    
    init(productListMock: ProductListModel) {
        self.productListMock = productListMock
    }
    
    override func getProducts(searchTerm: String?, completion: @escaping (Result<ProductListModel, Error>) -> Void) {
        getProductCalled = true
        completion(Result<ProductListModel, Swift.Error> {
            return productListMock
        })
    }
    override func getProducts(searchTerm: String?, pageNumber: Int, completion: @escaping (Result<ProductListModel, Error>) -> Void) {
        getProductCalled = true
        completion(Result<ProductListModel, Swift.Error> {
            return productListMock
        })
    }
}
extension NetworkProductMock {
    static var sampleMock : NetworkProductMock {
        NetworkProductMock(productListMock: ProductListModel(products: [Product(id: 123, productName: "Apple iPhone 6 32GB Grijs", reviewInformation: Review(reviewSummary: Review.ReviewSummary(average: 3.5, count: 5)), specs: ["32 GB opslagcapaciteit","iOS 11","Full-size"], nextDayDelivery: true, salesPriceIncVat: 150.3, imageURL: "https://image.coolblue.nl/300x750/products/818870")], currentPage: 1, pageSize: 3, totalResults: 1, pageCount: 3))

    }
}
