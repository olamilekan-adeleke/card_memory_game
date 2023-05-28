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
            if card.isMatched, !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card)
                    .padding(4)
                    .onTapGesture { viewModel.choose(card) }
            }
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

                    PieView(
                        startAngle: Angle(degrees: 0 - 90),
                        endAngle: Angle(degrees: 110 - 90)
                    )
                    .padding(5)
                    .foregroundColor(.red)
                    .opacity(0.5)

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
        static let fontScale: CGFloat = 0.70
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameVM()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(viewModel: game)
    }
}
