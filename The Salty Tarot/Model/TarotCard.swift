//
//  TarotCard.swift
//  The Salty Tarot
//
//  Created by Meggi on 01/01/26.
//

import Foundation

struct TarotCard: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
}
