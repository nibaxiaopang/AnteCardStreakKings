//
//  Suit.swift
//  AnteCardStreakKings
//
//  Created by jin fu on 2024/12/12.
//


import Foundation


enum AnteCardSuit : UInt8 {
    case spades = 0
    case clubs  = 1
    case diamonds = 2
    case hearts = 3
}


let ACE   : UInt8 = 1
let JACK  : UInt8 = 11
let QUEEN : UInt8 = 12
let KING  : UInt8 = 13

let suitStrings = ["♠︎", "♣︎", "♦︎", "♥︎"]
let rankStrings = [
    "", "A", "2", "3", "4", "5", "6", "7",
    "8", "9", "10", "J", "Q", "K"
]

func ==(left: AnteCard, right: AnteCard) -> Bool {
    return left.suit == right.suit && left.rank == right.rank
}


