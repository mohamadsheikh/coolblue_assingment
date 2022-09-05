//
//  ProductListViewModelTests.swift
//  coolblueTests
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import XCTest
@testable import coolblue

class ProductListViewModelTests: XCTestCase {
    
    func testRefreshAllData() {
        let mock = NetworkProductMock.sampleMock
        let viewModel = ProductListViewModel(repository: mock)
        viewModel.currentPage = 3
        viewModel.pageCount = 10
        
        viewModel.refreshAllData()
        
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.5)
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentPage, 1)
            XCTAssertEqual(viewModel.pageCount, 3)
            XCTAssertEqual(viewModel.dataSource.count, 1)
            XCTAssertEqual(viewModel.dataSource.first?.id, 123)
            XCTAssertEqual(viewModel.dataSource.first?.product.productName, "Apple iPhone 6 32GB Grijs")
            XCTAssertEqual(viewModel.dataSource.first?.product.imageURL, "https://image.coolblue.nl/300x750/products/818870")
        } else {
            XCTFail("Test delay failed")
        }
    }
    func testLoadMoreData() {
        let mock = NetworkProductMock.sampleMock
        
        let viewModel = ProductListViewModel(repository: mock)
        viewModel.pageCount = 3
        viewModel.currentPage = 2
        viewModel.loadMoreData()
        
        XCTAssertTrue(mock.getProductCalled,"get product should be called")
        XCTAssertEqual(viewModel.currentPage, 3)
        XCTAssertEqual(viewModel.pageCount, 3)
        
        mock.getProductCalled = false
        viewModel.loadMoreData()
        XCTAssertFalse(mock.getProductCalled,"get product should not be called")
        XCTAssertEqual(viewModel.currentPage, 3)
        XCTAssertEqual(viewModel.pageCount, 3)
    }
    func testLoadMoreDatasourceCount() {
        let mock = NetworkProductMock.sampleMock
        
        let viewModel = ProductListViewModel(repository: mock)
        viewModel.pageCount = 3
        viewModel.currentPage = 1
        viewModel.loadMoreData()
        
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.5)
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.dataSource.count, 1)
            XCTAssertTrue(mock.getProductCalled,"get product should be called")
            XCTAssertEqual(viewModel.currentPage, 1)
            XCTAssertEqual(viewModel.pageCount, 3)
        }
        
        // testing add more data
        viewModel.loadMoreData()
        
        let exp2 = expectation(description: "Test after 5 seconds")
        let result2 = XCTWaiter.wait(for: [exp2], timeout: 0.5)
        
        if result2 == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.dataSource.count, 2)
            XCTAssertTrue(mock.getProductCalled,"get product should be called")
        }
        
    }
    
    func testRefreshAllDataSourceReset() {
        let mock = NetworkProductMock.sampleMock
        let viewModel = ProductListViewModel(repository: mock)
        viewModel.refreshAllData()
        
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.5)
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentPage, 1)
            XCTAssertEqual(viewModel.pageCount, 3)
            XCTAssertEqual(viewModel.dataSource.first?.id, 123)
            XCTAssertEqual(viewModel.dataSource.first?.product.productName, "Apple iPhone 6 32GB Grijs")
            XCTAssertEqual(viewModel.dataSource.first?.product.imageURL, "https://image.coolblue.nl/300x750/products/818870")
        } else {
            XCTFail("Test delay failed")
        }
        viewModel.loadMoreData()
        
        let exp2 = expectation(description: "Test after 5 seconds")
        let result2 = XCTWaiter.wait(for: [exp2], timeout: 0.5)
        
        if result2 == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.dataSource.count,2)
        } else {
            XCTFail("Test delay failed")
        }
        
        viewModel.refreshAllData()
        
        let exp3 = expectation(description: "Test after 5 seconds")
        let result3 = XCTWaiter.wait(for: [exp3], timeout:0.5)
        
        if result3 == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.dataSource.count,1)
        } else {
            XCTFail("Test delay failed")
        }
    }
}
