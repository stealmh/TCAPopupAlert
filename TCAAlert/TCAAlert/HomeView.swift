//
//  HomeView.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: HomeFeature.self)
struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        Button(action: { send(.buttonTapped) }) {
                Text("팝업 보기")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert($store.scope(state: \.alert, action: \.alert))
        .alert($store.scope(state: \.remindAlert, action: \.alert))
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: .init(),
            reducer: { HomeFeature() }
        )
    )
}
