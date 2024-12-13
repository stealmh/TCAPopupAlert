//
//  View+alert.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import ComposableArchitecture
import SwiftUI

extension View {
    public func alert<MenuAction: Equatable>(
        _ item: Binding<Store<PopupAlertState<MenuAction>, MenuAction>?>
    ) -> some View {
        /// Binding으로 받은 현재 값
        let store = item.wrappedValue
        /// `PopupAlertState<MenuAction>`의 인스턴스
        let state = store?.withState { $0 }
        return self.alert(
            item: Binding(
                get: {
                    /// case 1) footer만 있을 때
                    if let _ = state?.footerButton {
                        state?.converted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    }
                    /// case 2) leadingButton, trailingButton이 있을 때
                    else if let _ = state?.leadingButton,
                            let _ = state?.trailingButton {
                        state?.twoButtonConverted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    }
                    /// case 3) 아무 버튼도 없을 때
                    else {
                        state?.noButtonConverted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    }
                },
                set: { if $0 == nil { item.transaction($1).wrappedValue = nil } }
            )
        )
    }
}


