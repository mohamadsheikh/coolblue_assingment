//
//  ReviewRating.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import SwiftUI

struct ReviewRating: View {
    
    var currentRating : Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                ReviewStar(state: index < currentRating ? .filled : .empty)
            }
        }
    }
}

struct ReviewRating_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRating(currentRating:1)
    }
}
