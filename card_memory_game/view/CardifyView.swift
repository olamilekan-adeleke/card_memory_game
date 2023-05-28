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

            if self.isFacedUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)

            } else {
                shape.fill()
            }
            
            // learn that implict animation does not work for view that are not on screen
            content.opacity(self.isFacedUp ? 1 : 0)
        }
    }

    private enum DrawingConstants {
        static let radius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFacedUp: Bool) -> some View {
        return self.modifier(CardifyView(isFacedUp: isFacedUp))
    }
}
