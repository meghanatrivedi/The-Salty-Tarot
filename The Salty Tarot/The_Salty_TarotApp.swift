//
//  The_Salty_TarotApp.swift
//  The Salty Tarot
//
//  Created by Meggi on 01/01/26.
//

import SwiftUI

@main
struct The_Salty_TarotApp: App {
    @StateObject private var viewModel = TarotViewModel()
    var body: some Scene {
        WindowGroup {
            MainTarotFlowView(viewModel: viewModel)
        }
    }
}
