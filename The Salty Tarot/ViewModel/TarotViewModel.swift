//
//  TarotViewModel.swift
//  The Salty Tarot
//
//  Created by Meggi on 01/01/26.
//

import SwiftUI
import Combine

class TarotViewModel: ObservableObject {
    enum DeckType {
        case tarot
        case oracle
    }
    
    @Published var activeDeckType: DeckType = .tarot
    @Published var selectedCards: [TarotCard] = []
    @Published var scrollOffset: CGFloat = 0
    
    @Published var animatingCardID: UUID? = nil
    
    var tarotCards: [TarotCard] = [
            TarotCard(name: "The Fool", imageName: "Tarot_card_back", description: "New beginnings, optimism, and trust in the universe."),
            TarotCard(name: "The Magician", imageName: "Tarot_card_back", description: "Manifestation, resourcefulness, and personal power."),
            TarotCard(name: "The High Priestess", imageName: "Tarot_card_back", description: "Intuition, sacred knowledge, and the subconscious mind."),
            TarotCard(name: "The Empress", imageName: "Tarot_card_back", description: "Femininity, beauty, nature, and abundance."),
            TarotCard(name: "The Emperor", imageName: "Tarot_card_back", description: "Authority, establishment, structure, and a father figure."),
            TarotCard(name: "The Hierophant", imageName: "Tarot_card_back", description: "Spiritual wisdom, religious beliefs, and tradition."),
            TarotCard(name: "The Lovers", imageName: "Tarot_card_back", description: "Love, harmony, relationships, and values alignment."),
            TarotCard(name: "The Chariot", imageName: "Tarot_card_back", description: "Control, willpower, success, and determination."),
            TarotCard(name: "Strength", imageName: "Tarot_card_back", description: "Courage, persuasion, influence, and compassion.")
        ]

        var oracleCards: [TarotCard] = [
            TarotCard(name: "The Moon Child", imageName: "verdant_guardian", description: "Look within for the answers you seek; your intuition is peaking."),
            TarotCard(name: "Solar Flare", imageName: "verdant_guardian", description: "A burst of energy is coming. Now is the time to take bold action."),
            TarotCard(name: "Star Dust", imageName: "verdant_guardian", description: "You are made of cosmic matter. Remember your divine origin."),
            TarotCard(name: "Golden Hour", imageName: "verdant_guardian", description: "Success is near. Bask in the warmth of your achievements."),
            TarotCard(name: "Deep Sea", imageName: "verdant_guardian", description: "Dive deep into your emotions to find the hidden pearl of wisdom."),
            TarotCard(name: "Mountain Peak", imageName: "verdant_guardian", description: "The climb is hard, but the view from the top is worth it."),
            TarotCard(name: "Wild Rose", imageName: "verdant_guardian", description: "Beauty often comes with thorns; protect your energy.")
        ]
    func selectCard(_ card: TarotCard) {
        if selectedCards.count < 3 {
            selectedCards.append(card)
        }
    }
}
