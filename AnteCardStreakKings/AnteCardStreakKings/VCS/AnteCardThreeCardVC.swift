//
//  ThreeCardVC.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//


import UIKit

class AnteCardThreeCardVC: UIViewController {

    // MARK: - Declare IBOutlets
    @IBOutlet var playerOneCardImages: [UIImageView]!
    @IBOutlet var playerTwoCardImages: [UIImageView]!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var imgPlayerOneWin: UIImageView!
    @IBOutlet weak var imgPlayerTwoWin: UIImageView!
    
    // MARK: - Declare Variables
    var totalTurns: Int = 500
    var currentTurn: Int = 1
    var playerOnePoints: Int = 0
    var playerTwoPoints: Int = 0
    
    let cardSuits = ["♠️", "♥️", "♦️", "♣️"]
    let cardValues = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }

    // MARK: - Functions
    private func setupGame() {
        imgPlayerOneWin.isHidden = true
        imgPlayerOneWin.image = UIImage.gifImageWithName("One")
        imgPlayerTwoWin.isHidden = true
        imgPlayerTwoWin.image = UIImage.gifImageWithName("Two")

        playerOnePoints = 0
        playerTwoPoints = 0
        currentTurn = 1

        for cardImage in playerOneCardImages {
            cardImage.image = UIImage(named: "backCard")
        }
        for cardImage in playerTwoCardImages {
            cardImage.image = UIImage(named: "backCard")
        }
    }

    private func randomCard() -> (UIImage?, String, String) {
        let randomSuit = cardSuits.randomElement()!
        let randomValue = cardValues.randomElement()!
        let cardName = "\(randomValue)\(randomSuit)"
        return (UIImage(named: cardName), randomValue, randomSuit)
    }

    private func evaluateHand(cardValues: [String], cardSuits: [String]) -> [String: String] {
        let ranks = cardValues.map { cardRank($0) }
        let sortedRanks = ranks.sorted()
        let suitCounts = Dictionary(grouping: cardSuits, by: { $0 }).mapValues { $0.count }

        // Determine Hand Ranking
        if sortedRanks == [10, 11, 12, 13, 14], suitCounts.values.contains(3) {
            return ["hand": "Royal Flush"]
        }
        if sortedRanks[2] - sortedRanks[0] == 2, suitCounts.values.contains(3) {
            return ["hand": "Straight Flush"]
        }
        if ranks[0] == ranks[1] && ranks[1] == ranks[2] {
            return ["hand": "Three of a Kind"]
        }
        if suitCounts.values.contains(3) {
            return ["hand": "Flush"]
        }
        if sortedRanks[2] - sortedRanks[0] == 2 {
            return ["hand": "Straight"]
        }
        if ranks[0] == ranks[1] || ranks[1] == ranks[2] {
            return ["hand": "Pair"]
        }

        // High Card
        let highestCardRank = sortedRanks.last!
        let highestCardValue = cardValues[ranks.firstIndex(of: highestCardRank)!]
        return ["hand": "High Card", "highCard": highestCardValue]
    }

    private func determineRoundWinner(playerOneCardValues: [String], playerOneCardSuits: [String], playerTwoCardValues: [String], playerTwoCardSuits: [String]) -> String {
        let playerOneHand = evaluateHand(cardValues: playerOneCardValues, cardSuits: playerOneCardSuits)
        let playerTwoHand = evaluateHand(cardValues: playerTwoCardValues, cardSuits: playerTwoCardSuits)
        
        let playerOneHandType = playerOneHand["hand"]!
        let playerTwoHandType = playerTwoHand["hand"]!
        
        if playerOneHandType == playerTwoHandType {
            let playerOneHighCards = playerOneCardValues.sorted { cardRank($0) > cardRank($1) }
            let playerTwoHighCards = playerTwoCardValues.sorted { cardRank($0) > cardRank($1) }

            for i in 0..<min(playerOneHighCards.count, playerTwoHighCards.count) {
                let playerOneCard = playerOneHighCards[i]
                let playerTwoCard = playerTwoHighCards[i]
                
                if cardRank(playerOneCard) > cardRank(playerTwoCard) {
                    return "Player One Wins with High Card \(playerOneCard)"
                } else if cardRank(playerOneCard) < cardRank(playerTwoCard) {
                    return "Player Two Wins with High Card \(playerTwoCard)"
                }
            }
            return "It's a tie with identical hands!"
        }
        
        let handStrengths = ["High Card", "Pair", "Flush", "Straight", "Three of a Kind", "Straight Flush", "Mini Royal Flush", "Royal Flush"]
        
        if let playerOneStrengthIndex = handStrengths.firstIndex(of: playerOneHandType),
           let playerTwoStrengthIndex = handStrengths.firstIndex(of: playerTwoHandType) {
            if playerOneStrengthIndex > playerTwoStrengthIndex {
                return "Player One Wins with \(playerOneHandType)"
            } else {
                return "Player Two Wins with \(playerTwoHandType)"
            }
        }
        return "It's a tie!"
    }


    func cardRank(_ card: String) -> Int {
        switch card {
        case "A": return 14
        case "K": return 13
        case "Q": return 12
        case "J": return 11
        case "10": return 10
        case "9": return 9
        case "8": return 8
        case "7": return 7
        case "6": return 6
        case "5": return 5
        case "4": return 4
        case "3": return 3
        case "2": return 2
        default: return 0
        }
    }

    private func showGameOverAlert() {
        let winner: String

        if playerOnePoints > playerTwoPoints {
            winner = "Player One"
        } else if playerTwoPoints > playerOnePoints {
            winner = "Player Two"
        } else {
            winner = "It's a Tie"
        }

        let alert = UIAlertController(title: "Game Over", message: "\(winner) wins the game!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.setupGame()
        }))

        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDealCard(_ sender: Any) {
        guard currentTurn <= totalTurns else {
            showGameOverAlert()
            return
        }

        var usedCards: Set<String> = []
        var playerOneCardValues: [String] = []
        var playerOneCardSuits: [String] = []
        var playerTwoCardValues: [String] = []
        var playerTwoCardSuits: [String] = []

        func getUniqueCard() -> (UIImage?, String, String) {
            var card: (UIImage?, String, String)
            repeat {
                card = randomCard()
            } while usedCards.contains(card.1 + card.2)
            usedCards.insert(card.1 + card.2)
            return card
        }

        for index in 0..<3 {
            let playerOneCard = getUniqueCard()
            let playerTwoCard = getUniqueCard()

            playerOneCardValues.append(playerOneCard.1)
            playerOneCardSuits.append(playerOneCard.2)
            playerTwoCardValues.append(playerTwoCard.1)
            playerTwoCardSuits.append(playerTwoCard.2)

            // Animate Player One Card
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                UIView.transition(
                    with: self.playerOneCardImages[index],
                    duration: 0.5,
                    options: .transitionFlipFromLeft,
                    animations: {
                        self.playerOneCardImages[index].image = playerOneCard.0
                    },
                    completion: nil
                )
            }

            // Animate Player Two Card
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                UIView.transition(
                    with: self.playerTwoCardImages[index],
                    duration: 0.5,
                    options: .transitionFlipFromLeft,
                    animations: {
                        self.playerTwoCardImages[index].image = playerTwoCard.0
                    },
                    completion: nil
                )
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let roundResult = self.determineRoundWinner(
                playerOneCardValues: playerOneCardValues,
                playerOneCardSuits: playerOneCardSuits,
                playerTwoCardValues: playerTwoCardValues,
                playerTwoCardSuits: playerTwoCardSuits
            )

            // Update points and show appropriate win image
            if roundResult.contains("Player One Wins") {
                self.playerOnePoints += 1
                self.imgPlayerOneWin.isHidden = false
                self.imgPlayerTwoWin.isHidden = true
            } else if roundResult.contains("Player Two Wins") {
                self.playerTwoPoints += 1
                self.imgPlayerTwoWin.isHidden = false
                self.imgPlayerOneWin.isHidden = true
            } else {
                self.imgPlayerOneWin.isHidden = true
                self.imgPlayerTwoWin.isHidden = true
            }

            let alert = UIAlertController(
                title: "Round \(self.currentTurn) Result",
                message: roundResult,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Next Turn", style: .default, handler: { _ in
                self.currentTurn += 1
                self.imgPlayerOneWin.isHidden = true
                self.imgPlayerTwoWin.isHidden = true
                if self.currentTurn > self.totalTurns {
                    self.showGameOverAlert()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }




}
