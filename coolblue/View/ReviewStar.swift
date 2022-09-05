//
//  ReviewStar.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import SwiftUI

struct ReviewStar: View {
    let state : StarState

    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(Color("Green"))
    }
}

extension ReviewStar {
    enum StarState { case filled, empty }
    
    var imageName : String {
        switch state {
        case .filled:
            return "star.circle.fill"
        default:
            return "star.circle"
        }
    }
}

struct ReviewStar_Previews: PreviewProvider {
    static var previews: some View {
        ReviewStar(state: .empty)
    }
}
