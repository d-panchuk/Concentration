//
//  ViewController.swift
//  Concentration
//
//  Created by Dima Panchuk on 3/2/19.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(cardPairsNumber: cardPairsNumber)
    var cardPairsNumber: Int { return cardButtons.count / 2 }
    
    var emojies: [String] = []
    private var cardEmoji = [Card:String]()
    private var selectedCardButtons: [UIButton] = []
    
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet { initCardEmojies() }
    }
    @IBOutlet private weak var guessesCounterLabel: UILabel! {
        didSet { setCounterUI(withValue: 0) }
    }
    
    func initCardEmojies() {
        var emojiesCopy = emojies
        for card in game.cards where cardEmoji[card] == nil {
            let emoji = emojiesCopy.remove(at: Int.random(in: 0..<emojiesCopy.count))
            cardEmoji[card] = emoji
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        let cardIndex = cardButtons.firstIndex(of: sender)!
        let didSelect = game.chooseCard(at: cardIndex)
        if didSelect {
            selectedCardButtons.append(sender)
            updateViewFromModel(lastChosenCardIndex: cardIndex)
        }
    }
    
    @IBAction private func touchRestartButton(_ sender: UIButton) {
        game.restart()
        cardEmoji.removeAll()
        selectedCardButtons.removeAll()
        cardButtons.forEach { cardButton in
            UIView.transition(
                with: cardButton,
                duration: 0.5,
                options: [.transitionFlipFromLeft],
                animations: { [unowned self] in
                    self.setCardFaceDownUI(for: cardButton)
            })
        }
        setCounterUI(withValue: 0)
        initCardEmojies()
    }
    
    private func updateViewFromModel(lastChosenCardIndex cardIndex: Int) {
        view.isUserInteractionEnabled = false
        
        let card = game.cards[cardIndex]
        let emoji = cardEmoji[card]!
        let lastSelectedButton = cardButtons[cardIndex]
        
        var completion: ((Bool) -> Void)? = { [unowned self] finished in
            self.view.isUserInteractionEnabled = true
        }

        if selectedCardButtons.count == 2 {
            if card.isMatched {
                completion = { [unowned self] finished in
                    self.selectedCardButtons.removeAll()
                    self.view.isUserInteractionEnabled = true
                }
            } else {
                completion = { [unowned self] finished in
                    for cardButton in self.selectedCardButtons {
                        UIView.transition(
                            with: cardButton,
                            duration: 0.5,
                            options: [.transitionFlipFromLeft],
                            animations: { [unowned self] in
                                self.setCardFaceDownUI(for: cardButton)
                        })
                    }
                    self.selectedCardButtons.removeAll()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
        
        UIView.transition(with: lastSelectedButton,
                          duration: 0.75,
                          options: [.transitionFlipFromLeft],
                          animations: { [unowned self] in self.setCardFaceUpUI(for: lastSelectedButton, with: emoji) },
                          completion: completion)
        
        setCounterUI(withValue: game.guessesCounter)
    }
    
    private func setCardFaceUpUI(for button: UIButton, with emoji: String) {
        button.setTitle(emoji, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.0603580784, alpha: 0)
    }
    
    private func setCardFaceDownUI(for button: UIButton) {
        button.setTitle("", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    private func setCounterUI(withValue guessesCounter: Int) {
        let text = "Guesses: \(guessesCounter)"
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 4.0,
            .strokeColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        guessesCounterLabel.attributedText = attributedText
    }
    
}
