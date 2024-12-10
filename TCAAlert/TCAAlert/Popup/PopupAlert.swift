//
//  PopupAlert.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI

/// Alert을 구성합니다.
/// - 이름은 기본적으로 프로젝트 이름를 따라가는 것이 좋습니다. ex) PokitAlert, WKAlert etc
public struct PopupAlert {
    public var message: Text?
    public var title: Text?
    public var leadingButton: Button?
    public var trailingButton: Button?
    public var footerButton: Button?
    
    /// - `button`이 `2개`일 때 사용하는 initalizer
    public init(
        title: Text? = nil,
        message: Text? = nil,
        leadingButton: Button? = nil,
        trailingButton: Button? = nil
    ) {
        self.title = title
        self.message = message
        self.leadingButton = leadingButton
        self.trailingButton = trailingButton
        self.footerButton = nil
    }
    /// - `button`이 `1개`일 때 사용하는 initalizer
    public init(
        title: Text? = nil,
        message: Text? = nil,
        footerButton: Button? = nil
    ) {
        self.title = title
        self.message = message
        self.leadingButton = nil
        self.trailingButton = nil
        self.footerButton = footerButton
    }
    
    public struct Button: Identifiable {
        public let action: () -> Void
        public let id: UUID
        public let title: Text?
        
        public init(
            title: Text?,
            action: @escaping () -> Void
        ) {
            self.action = action
            self.id = UUID()
            self.title = title
        }
    }
}

