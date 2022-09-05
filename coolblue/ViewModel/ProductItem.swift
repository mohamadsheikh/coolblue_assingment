//
//  ProductItem.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation
import UIKit

class ProductItem : ObservableObject, Identifiable {
    @Published var image : UIImage?
    
    let product : Product
    
    init(fromProduct product : Product) {
        self.product = product
        if let image = UIImage(systemName: "photo") {
            self.image = image
        }
    }
    
    private var imageURL : URL? {
        URL(string: self.product.imageURL)
    }
    
    var id : Int {
        product.id
    }
    
    func fetchImage() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let imageURL = self.imageURL as? NSURL else {return}
            
            NetworkImageCache.shared.load(url: imageURL) { image in
              if let img = image {
                self.image = img
              }
            }
        }
    }
}
extension ProductItem {
    static var samplePreview : ProductItem {
        ProductItem(fromProduct: Product(id: 123, productName: "Apple iPhone 6 32GB Grijs", reviewInformation: Review(reviewSummary: Review.ReviewSummary(average: 3.5, count: 5)), specs: ["32 GB opslagcapaciteit","iOS 11","Full-size"], nextDayDelivery: true, salesPriceIncVat: 150.3, imageURL: "https://image.coolblue.nl/300x750/products/818870"))
    }
   
    static var samplePreview2 : ProductItem {
            ProductItem(fromProduct:Product(id: 124, productName: "Apple Magic Mouse 2", reviewInformation: Review(reviewSummary: Review.ReviewSummary(average: 1, count: 20)), specs: [], nextDayDelivery: true, salesPriceIncVat: 1999, imageURL: "https://image.coolblue.nl/300x750/products/450716"))
    }
}
