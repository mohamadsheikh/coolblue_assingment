//
//  ProductListModel.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

struct ProductListModel : Decodable {
    let products : [Product]
    let currentPage : Int
    let pageSize: Int
    let totalResults : Int
    let pageCount: Int
}
