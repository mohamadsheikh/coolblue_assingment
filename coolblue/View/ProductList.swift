//
//  ProductList.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import SwiftUI

struct ProductList: View {
    
    @ObservedObject var viewModel : ProductListViewModel
    @State var searchTerm : String = ""
    
    @Environment(\.isSearching) private var isSearching: Bool
    
    init(viewModel: ProductListViewModel = ProductListViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        NavigationView {
            
            List {
                ForEach(viewModel.dataSource) { productItem in
                    ProductRow(productItem: productItem)
                }
                
                if viewModel.hasMoreRows {
                    HStack {
                        Spacer()
                        ProgressView()
                            .onAppear() {
                                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + 2) {
                                    viewModel.loadMoreData()
                                }
                            }
                        Spacer()
                    }
                }
            }
            .searchable(text: $searchTerm)
            .onSubmit(of: .search) {
                if !searchTerm.isEmpty {
                    viewModel.refreshAllData(searchTerm: searchTerm)
                }
            }
            .onChange(of: searchTerm, perform: { newValue in
                if searchTerm.isEmpty && !isSearching {
                    viewModel.refreshAllData()
                }
            })
            .navigationTitle("Products")
        }
        .navigationViewStyle(.stack)
        .alert(isPresented: $viewModel.isPresentError, content: {
            Alert(
                title: Text("Problem"),
                message: Text(viewModel.erorrMessage ?? "")
            )
        })
        .onAppear {
            viewModel.refreshAllData()
        }
    }
}

struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        ProductList()
    }
}
