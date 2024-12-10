//
//  PopupAlertState.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI
import ComposableArchitecture

/// PopupAlert을 TCA에서 사용할 수 있게 래핑한 구조체
public struct PopupAlertState<Action: Equatable>: Equatable {
    public var message: TextState?
    public var title: TextState?
    public var leadingButton: Button?
    public var trailingButton: Button?
    public var footerButton: Button?
    
    /// - `button`이 `1개`일 때 사용하는 initalizer
    public init(
        title: TextState? = nil,
        message: TextState? = nil,
        footerButton: Button? = nil
    ) {
        self.footerButton = footerButton
        self.message = message
        self.title = title
    }
    /// - `button`이 `2개`일 때 사용하는 initalizer
    public init(
        title: TextState? = nil,
        message: TextState? = nil,
        leadingButton: Button? = nil,
        trailingButton: Button? = nil
    ) {
        self.leadingButton = leadingButton
        self.trailingButton = trailingButton
        self.message = message
        self.title = title
    }
    
    public struct Button: Equatable {
        public let action: MenuAction?
        public let title: TextState?
        
        public init(
            title: TextState? = nil,
            action: MenuAction? = nil
        ) {
            self.action = action
            self.title = title
        }
    }
    
    public struct MenuAction: Equatable {
        public let action: Action
        public let animation: Animation
        
        public enum Animation: Equatable {
            case inherited                    /// 부모로부터 애니메이션을 받았을 때
            case explicit(SwiftUI.Animation?) /// 명시적으로 애니메이션을 지정하고 싶을 때
        }
        
        /// 명시적 지정 initalizer
        public init(
            action: Action,
            animation: SwiftUI.Animation?
        ) {
            self.action = action
            self.animation = .explicit(animation)
        }
        /// 애니메이션 상속 initalizer
        public init(action: Action) {
            self.action = action
            self.animation = .inherited
        }
    }
}
/// for ifLet
extension PopupAlertState: _EphemeralState {
    public static var actionType: Any.Type { Action.self }
}

