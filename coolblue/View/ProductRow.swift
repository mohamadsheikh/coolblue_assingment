//
//  ProductRow.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import SwiftUI

struct ProductRow: View {
    
    @StateObject var productItem : ProductItem
    
    var numberOfReviews : Int {
        productItem.product.reviewInformation.reviewSummary.count
    }
    
    var body: some View {
        
        HStack(alignment:.top) {
            if let image = productItem.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.15)
                    .clipped()
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                
                Text(productItem.product.productName)
                    .font(.headline)
                    .lineLimit(3)
                    .foregroundColor(Color("AccentColor"))

                HStack {
                    ReviewRating(currentRating: productItem.product.reviewCountInUIRange)
                    Text("\(numberOfReviews) \(numberOfReviews > 1 ? "reviews" : "review")")
                        .font(.footnote)
                        .foregroundColor(Color("AccentColor"))
                }
                
                ForEach(productItem.product.specs, id: \.self) { detail in
                    Text(detail)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Text(String(productItem.product.salesPriceIncVat))
                    .bold()
                
                if productItem.product.nextDayDelivery {
                    DeliverTomorrow()
                }
            }
        }
        .onAppear {
            productItem.fetchImage()
        }
    }
}

struct ProductRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductRow(productItem: ProductItem.samplePreview)
    }
}

extension Product {
    var reviewCountInUIRange : Int {
        Int(reviewInformation.reviewSummary.average.rounded() / 2)
    }
}

