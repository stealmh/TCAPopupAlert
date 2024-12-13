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
        VStack {
            /// TCA를 사용하지 않은 팝업
            TestView()
            /// TCA를 사용한 팝업
            Button(action: { send(.buttonTapped) }) {
                    Text("TCA 팝업 보기")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        .alert($store.scope(state: \.destination?.remindAlert, action: \.destination.remindAlert))
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
