//
//  CardifyView.swift
//  card_memory_game
//
//  Created by Enigma Kod on 28/05/2023.
//

import SwiftUI

struct CardifyView: ViewModifier {
    var isFacedUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.radius)
            
            if isFacedUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                
                content
            } else {
                shape.fill()
            }
        }
    }
    
    private enum DrawingConstants {
        static let radius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}
