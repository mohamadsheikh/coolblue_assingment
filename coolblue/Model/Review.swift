//
//  Review.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

struct Review : Decodable {
    let reviewSummary : ReviewSummary
    
    struct ReviewSummary : Decodable {
        let average : Double
        let count : Int
        
        enum CodingKeys: String, CodingKey {
            case average = "reviewAverage"
            case count = "reviewCount"
        }
    }
}
