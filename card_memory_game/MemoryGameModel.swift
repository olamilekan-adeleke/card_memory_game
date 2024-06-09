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
        let cardIndexWithFaceUp = cards.indices.filter { cards[$0].isFaceUp }
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

        shuffle()
    }

    mutating func chooseCard(_ card: Card) {
        if card.isMatched { return }
        if card.isFaceUp { return }

        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if let facedUpCardIndex = currentFacedUpCardIndex {
                let cardsMatched: Bool = checkIfCardContentMatched(
                    this: cardIndex,
                    that: facedUpCardIndex
                )

                if cardsMatched {
                    updateCardsPairsToMatching(pairOne: cardIndex, pairTwo: facedUpCardIndex)
                }

            } else {
                updateAllCardsFacedUp()
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
    }

    private mutating func updateAllCardsFacedUp() {
        for index in cards.indices {
            cards[index].isFaceUp = false
        }
    }

    mutating func shuffle() { cards.shuffle() }

    struct Card: Identifiable {
        let content: T
        let id: Int

        var isFaceUp = false {
            didSet {
                if isFaceUp { startUsingBonusTime() }
                else { stopUsingBonusTime() }
            }
        }

        var isMatched = false {
            didSet { stopUsingBonusTime() }
        }

        // MARK: - Bonus Time

        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
