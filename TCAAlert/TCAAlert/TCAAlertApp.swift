//
//  TCAAlertApp.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAAlertApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(store: Store(initialState: .init(), reducer: { HomeFeature() }))
        }
    }
}
