//
//  ContentView.swift
//  card_memory_game
//
//  Created by Enigma Kod on 19/05/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGameVM
    @State private var dealtCards = Set<Int>()
    @Namespace private var namespace

    private func isCardUnDealt(_ card: EmojiMemoryGameVM.Card) -> Bool {
        return dealtCards.contains(card.id) == false
    }

    private func animatedCardDelay(_ card: EmojiMemoryGameVM.Card) -> Animation {
        var delay = 0.0
        if let index = viewModel.cards.firstIndex(where: { card.id == $0.id }) {
            delay = Double(index) * (Contants.totalDealDuration / Double(viewModel.cards.count))
        }

        return Animation.easeIn(duration: Contants.dealDuration).delay(delay)
    }

    var body: some View {
        VStack {
            AspectVGridView(item: viewModel.cards, aspectRatio: 2 / 3, context: { card in
                if isCardUnDealt(card) || (card.isMatched && !card.isFaceUp) {
                    Rectangle().opacity(0)
                } else {
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: namespace)
                        .padding(4)
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                        .onTapGesture {
                            withAnimation(.easeIn) { viewModel.choose(card) }
                        }
                }
            })
            .foregroundColor(Contants.color)

            deckBody

            shuffleButton
        }
        .padding()
    }

    // MARK: - Sub - Views

    var shuffleButton: some View {
        Button {
            withAnimation { viewModel.shuffle() }
        } label: { Text("Shuffle") }
    }

    var deckBody: some View {
        ZStack {
            ForEach(viewModel.cards.filter { isCardUnDealt($0) }) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: namespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
            }
        }
        .frame(width: Contants.unDealWidth, height: Contants.unDealHeight)
        .foregroundColor(Contants.color)
        .onTapGesture {
            for card in viewModel.cards {
                withAnimation(animatedCardDelay(card)) {
                    dealtCards.insert(card.id)
                }
            }
        }
    }

    enum Contants {
        static let color: Color = .red
        static let aspectRatio: CGFloat = 2 / 3
        static let dealDuration: Double = 0.6
        static let totalDealDuration: Double = 2
        static let unDealHeight: CGFloat = 90
        static let unDealWidth = unDealHeight * aspectRatio
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
