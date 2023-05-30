//
//  CardifyView.swift
//  card_memory_game
//
//  Created by Enigma Kod on 28/05/2023.
//

import SwiftUI

struct CardifyView: AnimatableModifier {
    init(isFacedUp: Bool) {
        rotation = isFacedUp ? 0 : 180
    }

    // Question: Don't fully understand why this is done
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    var rotation: Double

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.radius)

            if animatableData < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)

            } else {
                shape.fill()
            }

            // learn that implict animation does not work for view that are not on screen
            // so this has to alraedy be in view to we can animate changes on it
            content.opacity(animatableData < 90 ? 1 : 0)
        }
        .rotation3DEffect(.degrees(animatableData), axis: (0, 1, 0))
    }

    private enum DrawingConstants {
        static let radius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFacedUp: Bool) -> some View {
        return modifier(CardifyView(isFacedUp: isFacedUp))
    }
}
