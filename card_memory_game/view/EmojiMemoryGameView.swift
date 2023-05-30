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
        VStack {
            AspectVGridView(item: viewModel.cards, aspectRatio: 2 / 3, context: { card in
                if card.isMatched, !card.isFaceUp {
                    Rectangle().opacity(0)
                } else {
                    CardView(card)
                        .padding(4)
                        .transition(AnyTransition.scale)
                        .onTapGesture {
                            withAnimation(.easeIn) { viewModel.choose(card) }
                        }
                }
            })
            .foregroundColor(.red)

            Button {
                withAnimation { viewModel.shuffle() }
            } label: { Text("Shuffle") }
        }
        .padding()
    }
}

struct CardView: View {
    private let card: MemoryGame<String>.Card

    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }

    var body: some View {
        GeometryReader { geomerty in
            ZStack {
                PieView(
                    startAngle: Angle(degrees: 0 - 90),
                    endAngle: Angle(degrees: 110 - 90)
                )
                .padding(5)
                .foregroundColor(.red)
                .opacity(0.5)

                Text(card.content)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(fontScale(thatFits: geomerty.size))
            }
            .cardify(isFacedUp: card.isFaceUp)
        }
    }

    private func fontScale(thatFits size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }

    private enum DrawingConstants {
        static let fontScale: CGFloat = 0.70
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameVM()
        return EmojiMemoryGameView(viewModel: game)
    }
}
