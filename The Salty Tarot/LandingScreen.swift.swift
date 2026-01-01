//
//  LandingScreen.swift.swift
//  The Salty Tarot
//
//  Created by Meggi on 01/01/26.
//
import SwiftUI
import Combine

struct LandingScreen: View {
    @ObservedObject var viewModel: TarotViewModel
    var nextPath: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.05, green: 0.02, blue: 0.12)
                .ignoresSafeArea()

            Image("fortune_teller_bg")
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 500)
                .clipped()
                .alignmentGuide(.top) { d in d[.top] }

            VStack {
                Spacer()
                HStack(spacing: 20) {
                    Button("TAROT") {
                        viewModel.activeDeckType = .tarot
                        nextPath()
                    }
                    .buttonStyle(MysticButtonStyle())

                    Button("ORACLE") {
                        viewModel.activeDeckType = .oracle
                        nextPath()
                    }
                    .buttonStyle(MysticButtonStyle())
                }
                .padding(.bottom, 50)
            }
        }
    }
}


struct MysticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .padding()
            .frame(width: 120)
            .background(Color.teal.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.teal, lineWidth: 2))
    }
}
