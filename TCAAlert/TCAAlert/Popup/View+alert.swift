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
        let store = item.wrappedValue
        let state = store?.withState { $0 }
        return self.alert(
            item: Binding(
                get: {
                    if let _ = state?.footerButton {
                        state?.converted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    } else {
                        state?.twoButtonConverted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    }
                },
                set: {
                    if $0 == nil {
                        item.transaction($1).wrappedValue = nil
                    }
                }
            )
        )
    }
    
    public func alertTwoButton<MenuAction: Equatable>(
        _ item: Binding<Store<PopupAlertState<MenuAction>, MenuAction>?>
    ) -> some View {
        let store = item.wrappedValue
        let state = store?.withState { $0 }
        return self.alert(
            item: Binding(
                get: {
                    state?.twoButtonConverted(
                        send: { store?.send($0) },
                        animation: { store?.send($0, animation: $1) }
                    )
                },
                set: {
                    if $0 == nil {
                        item.transaction($1).wrappedValue = nil
                    }
                }
            )
        )
    }
}


