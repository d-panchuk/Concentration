//
//  Concentration.swift
//  Concentration
//
//  Created by Dima Panchuk on 3/2/19.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    private(set) var guessesCounter = 0
    private var flippedCardIndex: Int?
    
    init(cardPairsNumber: Int) {
        for _ in 1...cardPairsNumber {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    mutating func chooseCard(at index: Int) -> Bool {
        guard !cards[index].isMatched, index != flippedCardIndex else { return false }
        flippedCardIndex == nil ? flipCard(at: index) : tryMatchCard(at: index)
        guessesCounter += 1
        return true
    }
    
    private mutating func flipCard(at index: Int) {
        flippedCardIndex = index
        cards[index].isFaceUp = true
    }
    
    private mutating func tryMatchCard(at index: Int) {
        guard let flippedCardIndex = flippedCardIndex else { return }
        if cards[index] == cards[flippedCardIndex] {
            cards[index].isFaceUp = true
            cards[index].isMatched = true
            cards[flippedCardIndex].isMatched = true
        } else {
            cards[flippedCardIndex].isFaceUp = false
        }
        self.flippedCardIndex = nil
    }
    
    mutating func restart() {
        cards.indices.forEach {
            cards[$0].isFaceUp = false
            cards[$0].isMatched = false
        }
        cards.shuffle()
        flippedCardIndex = nil
        guessesCounter = 0
    }
    
}
