//
//  ModelsTest.swift
//  coolblueTests
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import XCTest
@testable import coolblue

class ModelsTest: XCTestCase {
    
    func testReviewModel() {
        let jsonMap :[String:Any] = ["reviewSummary":["reviewAverage":9.3,"reviewCount":200]]
        let data = try! JSONSerialization.data(withJSONObject: jsonMap)
        
        let review = try! JSONDecoder().decode(Review.self, from: data)
        XCTAssertEqual(review.reviewSummary.average,9.3)
        XCTAssertEqual(review.reviewSummary.count,200)
    }

    func testProductModel() {
        let jsonMap :[String:Any] = ["productId":12,"productName":"apple","reviewInformation" :["reviewSummary":["reviewAverage":9.3,"reviewCount":200]],"nextDayDelivery":false,"salesPriceIncVat":200.3,"USPs":["spec1","spec2"],"productImage":"https://apple.com"]
        let data = try! JSONSerialization.data(withJSONObject: jsonMap)
        
        let product = try! JSONDecoder().decode(Product.self, from: data)
        XCTAssertEqual(product.id,12)
        XCTAssertEqual(product.specs,["spec1","spec2"])
        XCTAssertEqual(product.imageURL,"https://apple.com")
        XCTAssertEqual(product.productName,"apple")
    }

}
