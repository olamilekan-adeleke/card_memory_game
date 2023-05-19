//
//  EmojiMemoryGameVM.swift
//  card_memory_game
//
//  Created by Enigma Kod on 19/05/2023.
//

import Foundation

class EmojiMemoryGameVM {
    static let emojis = ["😃", "🌟", "🎉", "🌈", "🍕", "🐶", "🌸", "🏆", "📚", "💡", "🎁", "🍦", "🐱", "🌞", "🌺", "⭐️", "🎈", "🍔", "🐾", "🌼", "🥇", "🔍", "📖", "✨", "🎊", "🍩", "🌻", "🏅", "🎀", "🍓", "🐈", "🌝", "🌷", "🎂", "🚀", "🎵", "🌍", "🍎", "🐧", "🌹", "🏠", "💻"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }

    private var model: MemoryGame<String> = createMemoryGame()

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }

    func choose(_ card: MemoryGame<String>.Card) {
        model.chooseCard(card)
    }
}
