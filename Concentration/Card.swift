//
//  Card.swift
//  Concentration
//
//  Created by Dima Panchuk on 3/2/19.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int { return id }
    
    private var id: Int
    var isFaceUp = false
    var isMatched = false
    
    private static var cardIdFactory = -1
    
    private static func makeUniqueId() -> Int {
        cardIdFactory += 1
        return cardIdFactory
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    init() {
        self.id = Card.makeUniqueId()
    }
    
}
