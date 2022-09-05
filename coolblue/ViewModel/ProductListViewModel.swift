//
//  ProductListViewModel.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

class ProductListViewModel: ObservableObject {
    
    @Published private(set) var dataSource : [ProductItem] = []
    
    @Published var isPresentError = false
        
    var hasMoreRows : Bool {
        dataSource.count > 0 && currentPage < pageCount
    }
        
    var searchTerm : String?
    
    var erorrMessage : String?
    
    var currentPage = 1
    
    var pageCount = 1
    
    func refreshAllData(searchTerm:String?=nil) {
        
    }
    
}
private extension ProductListViewModel {
    
    func completionHandler(result: Result<ProductListModel, Error>)  {
        DispatchQueue.main.async { [weak self] in
            do {
                let productList = try result.get()
                
                self?.currentPage = productList.currentPage
                self?.pageCount = productList.pageCount
                
                let productItemList = productList.products.map({ product in
                    ProductItem(fromProduct: product)
                })
                
                self?.addDataToList(productItemList)
            }catch {
                self?.onFailure(error: error)
            }
        }
    }
    
    func addDataToList(_ products: [ProductItem]) {
        dataSource = dataSource + products
    }
    func onFailure(error: Error) {
        erorrMessage = "\(error)"
        isPresentError = true
    }
}
