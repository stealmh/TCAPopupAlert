//
//  PopupAlertState+convert.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI
/// PopupAlertState -> PopupAlert 매핑
extension PopupAlertState {
    /// - `footerButton`만 존재할 때
    public func converted(
        send: @escaping (Action) -> Void,
        animation: @escaping (Action, Animation?) -> Void
    ) -> PopupAlert {
        .init(
            title: self.title.map { Text($0) },
            message: self.message.map { Text($0) },
            footerButton: self.footerButton.map { $0.converted(send: send, animation: animation) },
            isBackgroundDismissable: self.isBackgroundDismissable
        )
    }
    /// - `leadingButton`, `trailingButton`이 존재할 때
    public func twoButtonConverted(
        send: @escaping (Action) -> Void,
        animation: @escaping (Action, Animation?) -> Void
    ) -> PopupAlert {
        .init(
            title: self.title.map { Text($0) },
            message: self.message.map { Text($0) },
            leadingButton: self.leadingButton.map { $0.converted(send: send, animation: animation) },
            trailingButton: self.trailingButton.map { $0.converted(send: send, animation: animation) },
            isBackgroundDismissable: self.isBackgroundDismissable
        )
    }
    /// - 버튼이 없을 때
    public func noButtonConverted(
        send: @escaping (Action) -> Void,
        animation: @escaping (Action, Animation?) -> Void
    ) -> PopupAlert {
        .init(
            title: self.title.map { Text($0) },
            message: self.message.map { Text($0) }
        )
    }
}
/// `PopupAlertState`의 `Button` -> `PopupAlert`의 `Button`으로 매핑
extension PopupAlertState.Button {
    fileprivate func converted(
        send: @escaping (Action) -> Void,
        animation: @escaping (Action, Animation?) -> Void
    ) -> PopupAlert.Button {
        .init(
            title: self.title.map { Text($0) },
            action: {
                if let action = self.action {
                    switch action.animation {
                    case .inherited:
                        send(action.action)
                    case let .explicit(ani):
                        animation(action.action, ani)
                    }
                }
            }
        )
    }
}
