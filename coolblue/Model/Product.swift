//
//  Product.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

struct Product : Decodable, Identifiable {
    let id : Int
    let productName : String
    let reviewInformation : Review
    let specs : [String]
    let nextDayDelivery : Bool
    let salesPriceIncVat : Double
    let imageURL : String
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case productName
        case reviewInformation
        case specs = "USPs"
        case nextDayDelivery
        case salesPriceIncVat
        case imageURL = "productImage"
    }
}
