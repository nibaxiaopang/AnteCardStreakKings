//
//  Card.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//

import Foundation

struct AnteCard : Hashable {
    let suit : AnteCardSuit
    let rank : UInt8 // 1 .. 13
    
    var description : String {
        return rankStrings[Int(rank)] + suitStrings[Int(suit.rawValue)]
    }
    
    var hashValue: Int {
        return Int(suit.rawValue*13 + rank - 1)
    }
    
    init(suit s : AnteCardSuit, rank r : UInt8) {
        suit = s;
        rank = r
    }
    
    init(dictionary dict : [String : AnyObject]) { // to retrieve from plist
        suit = AnteCardSuit(rawValue: (dict["suit"] as! NSNumber).uint8Value)!
        rank = (dict["rank"] as! NSNumber).uint8Value
    }
    
    func toDictionary() -> [String : AnyObject] { // to store in plist
        return [
            "suit" : NSNumber(value: suit.rawValue as UInt8),
            "rank" : NSNumber(value: rank as UInt8)
        ]
    }
    
    func isBlack() -> Bool {
        return suit == AnteCardSuit.spades || suit == AnteCardSuit.clubs
    }
    
    func isRed() -> Bool {
        return !isBlack()
    }
    
    func isSameColor(_ other : AnteCard) -> Bool {
        return isBlack() ? other.isBlack() : other.isRed()
    }
    
    static func deck() -> [AnteCard] {
        var d : [AnteCard] = []
        for s in 0 ... 3 {
            for r in 1 ... 13 {
                d.append(AnteCard(suit: AnteCardSuit(rawValue: UInt8(s))!, rank: UInt8(r)))
            }
        }
        return d
    }
    
}
