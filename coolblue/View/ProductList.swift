//
//  ProductList.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import SwiftUI

struct ProductList: View {
    
    @ObservedObject var viewModel : ProductListViewModel
    
    init(viewModel: ProductListViewModel = ProductListViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            ForEach(viewModel.dataSource) { productItem in
                ProductRow(productItem: productItem)
            }
            
        }.onAppear {
            viewModel.refreshAllData()
        }
    }
}
struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        ProductList()
    }
}
