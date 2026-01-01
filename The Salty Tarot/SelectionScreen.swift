//
//  SelectionScreen.swift
//  The Salty Tarot
//
//  Created by Meggi on 01/01/26.
//

import SwiftUI

struct SelectionScreen: View {
    @ObservedObject var viewModel: TarotViewModel
    @GestureState private var dragOffset: CGFloat = 0
    @Namespace private var animation
    
    @State private var wheelOffsetY: CGFloat = -500
    
    var nextPath: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.05, blue: 0.25),
                    Color(red: 0.05, green: 0.02, blue: 0.12)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Image("astrology_wheel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 430)
                    .frame(height: 220, alignment: .top) // show only top
                    .clipped()
                    .opacity(0.5)
                    .rotationEffect(
                        .degrees(Double(viewModel.scrollOffset + dragOffset) * 0.05)
                    )
                    .offset(y: wheelOffsetY + 100)
                    .animation(.easeInOut(duration: 0.6), value: wheelOffsetY)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                HStack {
                    Button {
                        onBack()
                    } label: {
                        Image("back_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                VStack(spacing: 20) {
                    Spacer().frame(height: 120)
                    
                    HStack(spacing: 18) {
                        ForEach(0..<3, id: \.self) { index in
                            SelectedSlot(
                                card: viewModel.selectedCards.indices.contains(index)
                                ? viewModel.selectedCards[index]
                                : nil,
                                index: index + 1,
                                namespace: animation
                            )
                        }
                    }
                    
                    VStack(spacing: 4) {
                        Text("Tap to pick")
                            .font(.custom("Avenir-Heavy", size: 22))
                            .foregroundColor(.white)
                        
                        Text("Choose up to 3 \(viewModel.activeDeckType == .tarot ? "Tarot" : "Oracle") cards")
                            .font(.custom("Avenir-Light", size: 13))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Spacer()
                
                ZStack {
                    let currentDeck = viewModel.activeDeckType == .tarot
                    ? viewModel.tarotCards
                    : viewModel.oracleCards
                    
                    ForEach(currentDeck.indices, id: \.self) { index in
                        let card = currentDeck[index]
                        
                        if shouldShowCard(card) {
                            CardView(
                                card: card,
                                index: index,
                                totalCount: currentDeck.count,
                                offset: viewModel.scrollOffset + dragOffset,
                                namespace: animation
                            )
                            .onTapGesture {
                                selectCard(card)
                            }
                        }
                    }
                }
                .offset(y: 100)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                viewModel.scrollOffset += value.translation.width
                            }
                        }
                )
                
                Spacer()
                
                VStack(spacing: 2) {
                    Image(systemName: "chevron.compact.up")
                    Text("Swipe to Move")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(2)
                }
                .foregroundColor(.white.opacity(0.45))
                .padding(.bottom, 16)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.selectedCards.removeAll()
            viewModel.scrollOffset = 0
            
            withAnimation(.easeOut(duration: 0.8)) {
                wheelOffsetY = -20
            }
        }
    }
    
    // MARK: - Helpers
    private func shouldShowCard(_ card: TarotCard) -> Bool {
        !viewModel.selectedCards.contains(where: { $0.id == card.id })
        || viewModel.animatingCardID == card.id
    }
    
    private func selectCard(_ card: TarotCard) {
        guard viewModel.selectedCards.count < 3 else { return }
        
        viewModel.animatingCardID = card.id
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            viewModel.selectCard(card)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewModel.animatingCardID = nil
        }
        
        if viewModel.selectedCards.count == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                nextPath()
            }
        }
    }
}

struct CardView: View {
    let card: TarotCard
    let index: Int
    let totalCount: Int
    let offset: CGFloat
    var namespace: Namespace.ID
    
    var body: some View {
        let center = CGFloat(totalCount - 1) / 2
        let relativeIndex = CGFloat(index) - center
        let spacing: CGFloat = 55
        let x = relativeIndex * spacing + offset * 0.45
        let rotation = Double(x / 14)
        let y = abs(x) * 0.18
        
        Image(card.imageName)
            .resizable()
            .matchedGeometryEffect(id: card.id, in: namespace)
            .frame(width: 150, height: 225)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.yellow.opacity(0.6), lineWidth: 1)
            )
            .rotationEffect(.degrees(rotation), anchor: .bottom)
            .offset(x: x, y: y)
            .zIndex(100 - abs(Double(x)))
            .shadow(color: .black.opacity(0.45), radius: 12, y: 8)
    }
}

struct SelectedSlot: View {
    let card: TarotCard?
    let index: Int
    var namespace: Namespace.ID
    
    private var fallbackImageName: String {
        switch index {
        case 1: return "lunar_escape"
        case 2: return "cosmic_serpent"
        case 3: return "lunar_escape"
        default: return "default"
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.yellow.opacity(0.9), .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.2
                )
                .frame(width: 92, height: 142)
                .shadow(color: .yellow.opacity(0.35), radius: 10)
            
            if let card = card {
                Image(card.imageName)
                    .resizable()
                    .matchedGeometryEffect(id: card.id, in: namespace)
                    .frame(width: 92, height: 142)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Image(fallbackImageName)
                    .resizable()
                    .matchedGeometryEffect(id: "index\(index)", in: namespace)
                    .frame(width: 92, height: 142)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

