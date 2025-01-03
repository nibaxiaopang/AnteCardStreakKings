//
//  that.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//


import Foundation
import UIKit

// Function to get the image for the given card
func imageForCard(_ card: AnteCard) -> UIImage {
    let suits = ["♠️", "♣️", "♦️", "♥️"]
    let ranks = [
        "", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"
    ]
   
    // Construct the image name using the rank and suit as per your convention
    let imageName = "\(ranks[Int(card.rank)])\(suits[Int(card.suit.rawValue)])"
    
    // Retrieve the image with the correct name
    let image = UIImage(named: imageName, in: nil, compatibleWith: nil)!
    return image
}

// CardLayer class that represents the card
class AnteCardLayer: CALayer {
    let card: AnteCard
    var faceUp: Bool {
        didSet {
            if faceUp != oldValue {
                let image = faceUp ? frontImage : AnteCardLayer.backImage
                self.contents = image?.cgImage
            }
        }
    }
    
    let frontImage: UIImage
    static let backImage = UIImage(named: "back-red-150-4.png", in: nil, compatibleWith: nil)
    
    // Init with card
    init(card: AnteCard) {
        self.card = card
        self.faceUp = true
        self.frontImage = imageForCard(card)
        
        super.init()
        
        // Setting the initial image to be displayed
        self.contents = frontImage.cgImage
        self.contentsGravity = .resizeAspectFill
        
        // Applying corner radius and enabling mask to bounds
        self.cornerRadius = 4
        self.masksToBounds = true
    }
    
    // Copy initializer for the layer (used in animations)
    override init(layer: Any) {
        if let layer = layer as? AnteCardLayer {
            card = layer.card
            faceUp = layer.faceUp
            frontImage = layer.frontImage
        } else {
            card = AnteCard(suit: AnteCardSuit.spades, rank: ACE)
            faceUp = true
            frontImage = imageForCard(card)
        }
        super.init(layer: layer)
        
        // Copying content properties from the previous layer
        self.contents = frontImage.cgImage
        self.contentsGravity = .resizeAspectFill
        
        // Applying corner radius and enabling mask to bounds
        self.cornerRadius = 4
        self.masksToBounds = true
    }
    
    // Required initializer for deserialization (if needed)
    required init?(coder aDecoder: NSCoder) {
        card = AnteCard(suit: AnteCardSuit.spades, rank: ACE)
        faceUp = true
        frontImage = imageForCard(card)
        super.init(coder: aDecoder)
        
        // Setting the initial image and gravity
        self.contents = frontImage.cgImage
        self.contentsGravity = .resizeAspectFill
        
        // Applying corner radius and enabling mask to bounds
        self.cornerRadius = 4
        self.masksToBounds = true
    }
}
