//
//  DeliverTomorrow.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import SwiftUI

struct DeliverTomorrow: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "checkmark.circle.fill")
            
            Text("Delivered\ntomorrow")
                .font(.caption).bold()
        }
        .foregroundColor(Color("Green"))

    }
}

struct DeliverTomorrow_Previews: PreviewProvider {
    static var previews: some View {
        DeliverTomorrow()
    }
}
