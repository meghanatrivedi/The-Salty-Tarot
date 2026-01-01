//
//  MainTarotFlow.swift
//  The Salty Tarot
//
//  Created by Meggi on 01/01/26.
//

import SwiftUI

struct MainTarotFlowView: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var currentPath: Int = 0

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.02, blue: 0.12).ignoresSafeArea()
            
            switch currentPath {
            case 0:
                LandingScreen(viewModel: viewModel) {
                    currentPath = 1
                }
            case 1:
                SelectionScreen(
                    viewModel: viewModel,
                    nextPath: {
                        currentPath = 2
                    },
                    onBack: {
                        withAnimation(.easeInOut) {
                            currentPath = 0
                        }
                    }
                )
            case 2:
                ReadingScreen(viewModel: viewModel) {
                    withAnimation {
                        currentPath = 0
                    }
                }
            default:
                LandingScreen(viewModel: viewModel) {
                    currentPath = 1
                }
            }
        }
        .animation(.easeInOut, value: currentPath)
    }
}
