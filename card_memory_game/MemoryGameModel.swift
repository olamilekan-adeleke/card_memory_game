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

    mutating func chooseCard(_ card: Card) {
        if let cardIndex = index(of: card) {
            cards[cardIndex].isFaceUp.toggle()
        }
    }

    func index(of card: Card) -> Int? {
        for indexCount in 0 ..< cards.count {
            if cards[indexCount].id == card.id {
                return indexCount
            }
        }

        return nil
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: T
        var id = UUID()
    }
}
