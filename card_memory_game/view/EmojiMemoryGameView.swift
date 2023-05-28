//
//  ContentView.swift
//  card_memory_game
//
//  Created by Enigma Kod on 19/05/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGameVM

    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
//                ForEach(viewModel.cards) { card in
//                    CardView(card)
//                        .aspectRatio(2 / 3, contentMode: .fit)
//                        .onTapGesture { viewModel.choose(card) }
//                }
//            }
//        }
        AspectVGridView(item: viewModel.cards, aspectRatio: 2 / 3, context: { card in
            CardView(card)
                .padding(4)
                .onTapGesture { viewModel.choose(card) }
        })
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}

struct CardView: View {
    private let card: MemoryGame<String>.Card

    init(_ card: MemoryGame<String>.Card) { self.card = card }

    var body: some View {
        GeometryReader { geomerty in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.radius)

                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text(card.content)
                        .font(.system(size: min(geomerty.size.height, geomerty.size.width) * DrawingConstants.fontScale))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }

    private enum DrawingConstants {
        static let radius: CGFloat = 10
        static let fontScale: CGFloat = 0.75
        static let lineWidth: CGFloat = 3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGameVM())
    }
}
