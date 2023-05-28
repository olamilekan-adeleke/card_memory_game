//
//  MemoryGameModel.swift
//  card_memory_game
//
//  Created by Enigma Kod on 19/05/2023.
//

import Foundation

struct MemoryGame<T> where T: Equatable {
    private(set) var cards: [Card]

    private var currentFacedUpCardIndex: Int? {
        let cardIndexWithFaceUp = cards.indices.filter({ cards[$0].isFaceUp })
        if cardIndexWithFaceUp.count == 1 {
            return cardIndexWithFaceUp.first
        } else {
            return nil
        }
    }

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> T) {
        cards = []

        for pairIndex in 0 ..< numberOfPairsOfCards {
            let card = createCardContent(pairIndex)

            cards.append(Card(content: card, id: pairIndex * 2))
            cards.append(Card(content: card, id: (pairIndex * 2) + 1))
        }
    }

    mutating func chooseCard(_ card: Card) {
        if card.isMatched { return }
        if card.isFaceUp { return }

        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            print("Index: \(cardIndex)")

            if let facedUpCardIndex = currentFacedUpCardIndex {
                print("facedUpCardIndex: \(facedUpCardIndex)")
                let cardsMatched: Bool = checkIfCardContentMatched(
                    this: cardIndex,
                    that: facedUpCardIndex
                )

                if cardsMatched {
                    updateCardsPairsToMatching(pairOne: cardIndex, pairTwo: facedUpCardIndex)
                }

            } else {
                updateAllCardsFacedUp()
                print("currentFacedUpCardIndex: \(String(describing: currentFacedUpCardIndex))")
            }

            cards[cardIndex].isFaceUp.toggle()
        }
    }

    private func checkIfCardContentMatched(this: Int, that: Int) -> Bool {
        return cards[this].content == cards[that].content
    }

    private mutating func updateCardsPairsToMatching(pairOne: Int, pairTwo: Int) {
        print("isMatched: \(true)")
        cards[pairOne].isMatched = true
        cards[pairTwo].isMatched = true

        print("currentFacedUpCardIndex: \(String(describing: currentFacedUpCardIndex))")
    }

    private mutating func updateAllCardsFacedUp() {
        for index in cards.indices {
            cards[index].isFaceUp = false
        }
    }

    struct Card: Identifiable {
        let content: T
        let id: Int
        var isFaceUp: Bool = true
        var isMatched: Bool = false
    }
}
