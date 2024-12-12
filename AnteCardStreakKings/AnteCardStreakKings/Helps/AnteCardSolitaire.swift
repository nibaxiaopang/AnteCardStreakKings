//
//  Solitaire.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//

import Foundation

class AnteCardSolitaire {
    var stock : [AnteCard]
    var waste : [AnteCard]
    var foundation : [[AnteCard]]
    var tableau : [[AnteCard]]
    
    fileprivate var faceUpCards : Set<AnteCard>;
    
    init() {
        stock = AnteCard.deck()
        waste = []
        foundation = [[],[],[],[]]
        tableau = [[], [], [], [], [], [], []]
        faceUpCards = []
    }
    
    init(dictionary dict : [String : AnyObject]) { // for retrieving from plist
        let stockArray = dict["stock"] as! [[String : AnyObject]]
        stock = stockArray.map{AnteCard(dictionary: $0)}
        
        let wasteArray = dict["waste"] as! [[String : AnyObject]]
        waste = wasteArray.map{AnteCard(dictionary: $0)}
        
        let foundationArray = dict["foundation"] as! [[[String : AnyObject]]]
        foundation = [[],[],[],[]]
        for f in 0 ..< 4 {
            foundation[f] = foundationArray[f].map{AnteCard(dictionary: $0)}
        }
        
        let tableauArray = dict["tableau"] as! [[[String : AnyObject]]]
        tableau = [[], [], [], [], [], [], []]
        for t in 0 ..< 7 {
            tableau[t] = tableauArray[t].map{AnteCard(dictionary: $0)}
        }
        
        let faceUpCardsArray = dict["faceUpCards"] as! [[String : AnyObject]]
        faceUpCards = []
        faceUpCardsArray.forEach{
            faceUpCards.insert(AnteCard(dictionary:$0))
        }
    }
    
    func toDictionary() -> [String : AnyObject] {  // for storing in plist
        let stockArray = stock.map{$0.toDictionary()}
        let wasteArray = waste.map{$0.toDictionary()}
        let foundationArray = foundation.map {
            $0.map{$0.toDictionary()}
        }
        let tableauArray = tableau.map {
            $0.map{$0.toDictionary()}
        }
        let faceUpCardsArray = faceUpCards.map{$0.toDictionary()}
        return [
            "stock" : stockArray as NSArray,
            "waste" : wasteArray as NSArray,
            "foundation" : foundationArray as NSArray,
            "tableau" : tableauArray as NSArray,
            "faceUpCards" : faceUpCardsArray as NSArray
        ]
    }
    
    func isCardFaceUp(_ card : AnteCard) -> Bool {
        return faceUpCards.contains(card)
    }
    
    func collectAllCardsIntoStock() { // order not important
        stock += waste
        waste.removeAll()
        for i in 0 ..< 4 {
            stock += foundation[i]
            foundation[i].removeAll()
        }
        for i in 0 ..< 7 {
            stock += tableau[i]
            tableau[i].removeAll()
        }
        faceUpCards.removeAll()
    }
    
    func collectWasteCardsIntoStock() { // order is important
        let n = waste.count
        for _ in 0 ..< n {
            let card = waste.popLast()!
            stock.append(card)
            faceUpCards.remove(card)
        }
    }
    
    func undoCollectWasteCardsIntoStock() {
        while !stock.isEmpty {
            let card = stock.popLast()!
            faceUpCards.insert(card)
            waste.append(card)
        }
    }
    
    func shuffeStock(numShuffles num : Int) {
        let n = stock.count
            for _ in 1 ... num {
                for j in 0 ..< n {
                    let k = Int(arc4random_uniform(UInt32(n)))
                    (stock[j], stock[k]) = (stock[k], stock[j])
                }
        }
    }
    
    func dealCardsFromStockToTableaux() {
        assert(stock.count == 52)
        for i in 0 ..< 7 {
            for j in i ..< 7 {
                let card = stock.popLast()!
                tableau[j].append(card)
                if i == j {
                    faceUpCards.insert(card) // last card is face up
                }
            }
        }
    }
    
    func freshGame() {
        collectAllCardsIntoStock()
        shuffeStock(numShuffles: 5)
        dealCardsFromStockToTableaux()
    }
    
    func fanBeginningWithCard(_ card : AnteCard) -> [AnteCard]? {
        for i in 0 ..< 7 {
            let cards = tableau[i]
            let numCards = cards.count
            for j in 0 ..< numCards {
                if card == cards[j] {
                    var fan : [AnteCard] = []  // could have used ArraySlice
                    for k in j ..< numCards {  // but they're kinda evil
                        fan.append(cards[k])
                    }
                    return fan
                }
            }
        }
        return nil
    }
    
    func canDropCard(_ card : AnteCard, onFoundation i : Int) -> Bool {
        if foundation[i].isEmpty {
            return card.rank == ACE
        } else {
            let topCard = foundation[i].last!
            return card.suit == topCard.suit && card.rank == topCard.rank + 1
        }
    }
    
    //
    // Return stack that card came from (for undo information)
    //
    func didDropCard(_ card : AnteCard, onFoundation i : Int) -> AnteCardStack {
        let cardStack = findAndRemoveCardFromStack(card)
        foundation[i].append(card)
        return cardStack
    }
    
    func undoDidDropCard(_ card : AnteCard, fromStack source : AnteCardStack, onFoundation i : Int) {
        let card = foundation[i].popLast()!
        switch(source) {
        case .waste:
            waste.append(card)
        case .foundation(let index):
            foundation[index].append(card)
        case .tableau(let index):
            tableau[index].append(card)
        default: break
        }
    }
    
    func canDropCard(_ card : AnteCard, onTableau i : Int) -> Bool {
        if tableau[i].isEmpty {
            return card.rank == KING
        } else {
            let topCard = tableau[i].last!
            return isCardFaceUp(topCard) && card.rank == topCard.rank - 1 && !card.isSameColor(topCard)
        }
    }
 
    //
    // Return stack that card came from (for undo information)
    //
    func didDropCard(_ card : AnteCard, onTableau i : Int) -> AnteCardStack {
        let cardStack = findAndRemoveCardFromStack(card)
        tableau[i].append(card)
        return cardStack
    }
   
    func undoDidDropCard(_ card : AnteCard, fromStack source : AnteCardStack, onTableau i : Int) {
        let card = tableau[i].popLast()!
        switch(source) {
        case .waste:
            waste.append(card)
        case .foundation(let index):
            foundation[index].append(card)
        case .tableau(let index):
            tableau[index].append(card)
        default: break
        }
    }
    

    func canDropFan(_ cards : [AnteCard], onTableau i : Int) -> Bool {
        if let card = cards.first {
            return canDropCard(card, onTableau: i)
        }
        return false;
    }
 
    func didDropFan(_ cards : [AnteCard], onTableau i : Int) -> AnteCardStack {
        let cardStack = findAndRemoveCardFanFromStack(cards)
        tableau[i] += cards
        return cardStack
    }
    
    func undoDidDropFan(_ cards : [AnteCard], fromStack source : AnteCardStack, onTableau i : Int) {
        tableau[i].removeLast(cards.count)
        switch(source) {
        case .foundation(let index):
            foundation[index] += cards;
        case .tableau(let index):
            tableau[index] += cards
        default: break
        }
    }
    
    func canFlipCard(_ card : AnteCard) -> Bool {
        if isCardFaceUp(card) {
            return false
        } else {
            for i in 0 ..< 7 {
                let topCard = tableau[i].last
                if card == topCard {
                    return true
                }
            }
        }
        return false
    }
    
    func didFlipCard(_ card : AnteCard) {
        faceUpCards.insert(card)
    }
    
    func undoFlipCard(_ card : AnteCard) {
        faceUpCards.remove(card)
    }
    
    func canDealCard() -> Bool {
        return stock.count > 0
    }
    
    func didDealCard() {
        let card = stock.popLast()!
        waste.append(card)
        faceUpCards.insert(card)
    }
    
    func undoDealCard() {
        let card = waste.popLast()!
        faceUpCards.remove(card)
        stock.append(card)
    }
    
    //
    // Deal 0 to num cards from stock to waste.
    // Returns cards actually dealt (so view can animate them, and
    // we home many cards were dealt for an undo).
    //
    func dealCards(_ num : Int) -> [AnteCard] {
        var cards : [AnteCard] = []
        let max = min(stock.count, num)
        for _ in 0 ..< max {
            let card = stock.popLast()!
            faceUpCards.insert(card)
            cards.append(card)
            waste.append(card)
        }
        return cards
    }
    
    func undoDealCards(_ num : Int) {
        for _ in 0 ..< num {
            let card = waste.popLast()!
            faceUpCards.remove(card)
            stock.append(card)
        }
    }
    
    func gameWon() -> Bool {
        for i in 0 ..< 4 {
            if foundation[i].count != 13 {
                return false
            }
        }
        return true
    }
    
    func dump() {  // dump state of model to console (for diagnostics)
        print("=================")
        print("stock:")
        stock.forEach {card in print(card.description + ", ", terminator:"")}
        print()
        print("waste:")
        waste.forEach {card in print(card.description + ", ", terminator:"")}
        print()
        for (i, cards) in foundation.enumerated() {
            print("foundation[\(i)]:")
            cards.forEach {card in print(card.description + ", ", terminator:"")}
            print()
        }
        for (i, cards) in tableau.enumerated() {
            print("tableau[\(i)]:")
            cards.forEach {card in print(card.description + ", ", terminator:"")}
            print()
        }
    }
    
    //
    // Find a card stack with 'card' on top
    //
    fileprivate func findCardStackWithCard(_ card : AnteCard) -> AnteCardStack? {
        if card == waste.last {
            return AnteCardStack.waste
        } else if card == stock.last {
            return AnteCardStack.stock
        } else {
            for i in 0 ..< 4 {
                if card == foundation[i].last {
                    return AnteCardStack.foundation(i)
                }
            }
            for i in 0 ..< 7 {
                if card == tableau[i].last {
                    return AnteCardStack.tableau(i)
                }
            }
        return nil
        }
    }
    
    fileprivate func findAndRemoveCardFromStack(_ card : AnteCard) -> AnteCardStack {
        let cardStack = findCardStackWithCard(card)!
        switch(cardStack) {
        case .waste:
            waste.removeLast()
        case .foundation(let index):
            foundation[index].removeLast()
        case .tableau(let index):
            tableau[index].removeLast()
        case .stock:
            stock.removeLast()
        }
        return cardStack
    }
    
    fileprivate func findAndRemoveCardFanFromStack(_ cards : [AnteCard]) -> AnteCardStack {
        let card = cards.last!
        let cardStack = findCardStackWithCard(card)!
        switch(cardStack) {
        case .foundation(let index):
            foundation[index].removeLast(cards.count)
        case .tableau(let index):
            tableau[index].removeLast(cards.count)
        default: break // shouldn't happen
        }
        return cardStack
    }
    
}
