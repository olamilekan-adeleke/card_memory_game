//
//  EmojiMemoryGameVM.swift
//  card_memory_game
//
//  Created by Enigma Kod on 19/05/2023.
//

import Foundation

class EmojiMemoryGameVM: ObservableObject {
    typealias Card = MemoryGame<String>.Card

    private static let emojis = ["😃", "🌟", "🎉", "🌈", "🍕", "🐶", "🌸", "🏆", "📚", "💡", "🎁", "🍦", "🐱", "🌞", "🌺", "⭐️", "🎈", "🍔", "🐾", "🌼", "🥇", "🔍", "📖", "✨", "🎊", "🍩", "🌻", "🏅", "🎀", "🍓", "🐈", "🌝", "🌷", "🎂", "🚀", "🎵", "🌍", "🍎", "🐧", "🌹", "🏠", "💻"]

    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private var model: MemoryGame<String> = createMemoryGame()

    var cards: [Card] { model.cards }

    // MARK: - Intents

    func choose(_ card: Card) {
        model.chooseCard(card)
    }
}
