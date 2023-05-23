//
//  MemoryGameModel.swift
//  card_memory_game
//
//  Created by Enigma Kod on 19/05/2023.
//

import Foundation

struct MemoryGame<T> where T: Equatable {
    private(set) var cards: [Card]

    var currentFacedUpCardIndex: Int?

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
//                let cardsMatched: Bool = checkIfCardContentMatched(
//                    this: cardIndex,
//                    that: facedUpCardIndex
//                )
//                if cardsMatched {
//                    updateCardsPairsToMatching(pairOne: cardIndex, pairTwo: facedUpCardIndex)
//                    currentFacedUpCardIndex = nil
//                } else {
//                    updateAllCardsFacedUp()
//                    currentFacedUpCardIndex = cardIndex
//                }

                if cards[cardIndex].content == cards[facedUpCardIndex].content {
                    print("isMatched: \(true)")
                    cards[cardIndex].isMatched = true
                    cards[facedUpCardIndex].isMatched = true

                    currentFacedUpCardIndex = nil
                    print("\(cards)")
                    print("currentFacedUpCardIndex: \(String(describing: currentFacedUpCardIndex))")

                } else {
                    for index in cards.indices {
                        cards[index].isFaceUp = false
                    }
                    currentFacedUpCardIndex = cardIndex
                    print("\(cards)")
                    print("currentFacedUpCardIndex: \(String(describing: currentFacedUpCardIndex))")
                }
            }

            cards[cardIndex].isFaceUp.toggle()
//            print("\(cards)")
        }
    }

//    func checkIfCardContentMatched(this: Int, that: Int) -> Bool {
//        return cards[this].content == cards[that].content
//    }
//
//    mutating func updateCardsPairsToMatching(pairOne: Int, pairTwo: Int) {
//        cards[pairOne].isMatched = true
//        cards[pairTwo].isMatched = true
//    }
//
//    mutating func updateAllCardsFacedUp() {
//        for index in cards.indices {
//            cards[index].isFaceUp = false
//        }
//    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: T
        var id: Int
    }
}


extension Array {
    
}
