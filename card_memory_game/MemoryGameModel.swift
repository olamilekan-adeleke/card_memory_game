//
//  MemoryGameModel.swift
//  card_memory_game
//
//  Created by Enigma Kod on 19/05/2023.
//

import Foundation

struct MemoryGame<T> {
    private(set) var cards: [Card]

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> T) {
        cards = []

        for pairIndex in 0 ..< numberOfPairsOfCards {
            let card = createCardContent(pairIndex)

            cards.append(Card(content: card))
            cards.append(Card(content: card))
        }
    }

    func chooseCard(_ card: Card) {}

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: T
        var id = UUID()
    }
}
