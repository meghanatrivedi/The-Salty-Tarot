//
//  ReadingScreen.swift
//  The Salty Tarot
//
//  Created by Meggi on 01/01/26.
//

import SwiftUI

struct ReadingScreen: View {
    @ObservedObject var viewModel: TarotViewModel
    var onBack: () -> Void
    
    @State private var isAnimating = false
    let cards = ["cosmic_serpent", "lunar_escape", "verdant_guardian", "cosmic_serpent", "lunar_escape"]
    
    var body: some View {
        ZStack {
            Color(hex: "0F0421")
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [Color(hex: "2B0B52"), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Image("stars_overlay")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                HStack {
                    Button {
                        onBack()
                    } label: {
                        Image("back_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 8) {
                            Text("Today's Destiny")
                                .font(.custom("Avenir-Medium", size: 24))
                                .foregroundColor(.white)
                            
                            Text("14 November 2025")
                                .font(.custom("Avenir-Light", size: 14))
                                .foregroundColor(Color(hex: "FFD700").opacity(0.8))
                        }
                        .padding(.top, 20)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: -50) {
                                
                                ForEach(0..<cards.count, id: \.self) { index in
                                    GeometryReader { geometry in
                                        let midX = geometry.frame(in: .global).midX
                                        let screenMidX = UIScreen.main.bounds.width / 2
                                        let distance = abs(midX - screenMidX)
                                        
                                        let isCentered = distance < 80
                                        
                                        ZStack {
                                            if isCentered {
                                                Circle()
                                                    .fill(Color.purple.opacity(0.4))
                                                    .frame(width: 250, height: 250)
                                                    .blur(radius: 50)
                                            }
                                            
                                            Image(cards[index])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 250)
                                                .cornerRadius(isCentered ? 15 : 12)
                                                .opacity(isCentered ? 1.0 : 0.3)
                                                .shadow(color: Color.purple.opacity(isCentered ? 0.7 : 0), radius: 30)
                                                .scaleEffect(isCentered ? 1.0 : 0.85)
                                                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: isCentered)
                                        }
                                        
                                        .zIndex(100 - distance)
                                    }
                                    .frame(width: 180, height: 350)
                                }
                            }
                            .padding(.horizontal, (UIScreen.main.bounds.width - 180) / 2)
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .frame(height: 380)
                        .padding(.top, 10)
                        
                        
                        // MARK: - Description Box
                        VStack(alignment: .leading, spacing: 16) {
                            Text("The Verdant Guardian")
                                .font(.custom("Avenir-Heavy", size: 20))
                                .foregroundColor(.white)
                            
                            Text("Your spirit is rooted, yet ready to grow. This card reveals your inherent stability and strength. You have built a foundation that can weather any season. Now is the time to reach for the light; the universe promises abundance and vitality in your current endeavors. Protect what you have planted, and you shall harvest greatly.")
                                .font(.custom("Avenir-Light", size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                        
                        Color.clear.frame(height: 120)
                    }
                }
            }
            
            // MARK: - Floating Button
            VStack {
                Spacer()
                Button {
                    onBack()
                } label: {
                    Text("Complete Reading")
                        .font(.custom("Avenir-Heavy", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "A36BFF"), Color(hex: "6C2BD9")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(30)
                        .shadow(color: Color(hex: "6C2BD9").opacity(0.5), radius: 15, y: 8)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255
        g = Double((int >> 8) & 0xFF) / 255
        b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
