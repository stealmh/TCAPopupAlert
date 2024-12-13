//
//  PopupAlertModifier.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI

extension View {
    public func alert(item: Binding<PopupAlert?>) -> some View {
        self.modifier(PopupAlertModifier(item: item))
    }
}

private struct PopupAlertModifier: ViewModifier {
    @Binding var item: PopupAlert?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if let item {
                    /// 배경색을 수정해보세요!
                    Color.black.opacity(0.1)
                        .onTapGesture {
                            withAnimation {
                                /// 배경을 터치하면 화면이 사라지는 옵션을 `true`로 설정했을 때
                                if item.isBackgroundDismissable {
                                    self.item = nil
                                }
                            }
                        }
                        /// 전환 애니메이션도 수정해보세요!
                        .transition(.opacity.animation(.linear(duration: 0.4)))
                        .ignoresSafeArea()
                }
            }
            .overlay {
                if let menu = self.item {
                    VStack(alignment: .leading, spacing: 10) {
                        if let title = menu.title {
                            title
                                .bold()
                        }
                        
                        if let message = menu.message {
                            message
                                .font(.callout)
                        }
                        
                        if let lb = menu.leadingButton,
                           let tb = menu.trailingButton {
                            HStack {
                                commonButton(
                                    button: lb,
                                    color: .green
                                )
                                commonButton(
                                    button: tb,
                                    color: .gray.opacity(0.8)
                                )
                            }
                        }
                        
                        if let fb = menu.footerButton {
                            commonButton(
                                button: fb,
                                color: .green
                            )
                        }
                        
                    }
                    .padding(20)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                    }
                    .padding(.horizontal, 20)
                    /// 전환 애니메이션도 수정해보세요!
                    .transition(.opacity.animation(.linear(duration: 0.3)))
                }
            }
    }
    
    func commonButton(button: PopupAlert.Button, color: Color) -> some View {
        Button(action: { button.action() }) {
            HStack {
                Spacer()
                button.title
                    .foregroundStyle(.white)
                    .bold()
                Spacer()
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(color)
        }
    }
}
//MARK: - Preview
#if DEBUG
struct TestView: View {
    let oneButtonpopupCase: [PopupAlert] = [Self.case1, Self.case2, Self.case3, Self.case4]
    let twoButtonpopupCase: [PopupAlert] = [Self.case5, Self.case6, Self.case7, Self.case8]
    @State var alert: PopupAlert?
    
    var body: some View {
        List {
            Section("One Button") {
                ForEach(0..<oneButtonpopupCase.count) { idx in
                    VStack {
                        Button("case \(idx + 1)") {
                            withAnimation {
                                self.alert = oneButtonpopupCase[idx]
                            }
                        }
                    }
                }
            }
            
            Section("Two Button") {
                ForEach(0..<twoButtonpopupCase.count) { idx in
                    VStack {
                        Button("case \(idx + 1)") {
                            withAnimation {
                                self.alert = twoButtonpopupCase[idx]
                            }
                        }
                    }
                }
            }
        }
        .alert(item: self.$alert.animation())
    }
}
extension TestView {
    /// - `title`: O
    /// - `message`: O
    /// - `footerButton`: O
    static let case1 = PopupAlert(
        title: Text("제목과"),
        message: Text("메세지와 버튼이 있어요"),
        footerButton: .init(
            title: Text("확인"),
            action: {}
        )
    )
    /// - `title`: X
    /// - `message`: O
    /// - `footerButton`: O
    static let case2 = PopupAlert(
        message: Text("메세지와 버튼만 있어요"),
        footerButton: .init(
            title: Text("확인"),
            action: {}
        )
    )
    /// - `title`: O
    /// - `message`: X
    /// - `footerButton`: O
    static let case3 = PopupAlert(
        title: Text("제목과 버튼만 있어요"),
        footerButton: .init(
            title: Text("확인"),
            action: {}
        )
    )
    
    /// - `title`: O
    /// - `message`: O
    /// - `footerButton`: X
    static let case4 = PopupAlert(
        title: Text("제목과"),
        message: Text("메세지만 있어요!")
    )
    
    /// - `title`: O
    /// - `message`: O
    /// - `leadingButton`: O
    /// - `trailingButton`: O
    static let case5 = PopupAlert(
        title: Text("제목과"),
        message: Text("메세지와 버튼이 있어요"),
        leadingButton: .init(title: Text("확인"),action: {}),
        trailingButton: .init(title: Text("취소"), action: {})
    )
    
    /// - `title`: X
    /// - `message`: O
    /// - `leadingButton`: O
    /// - `trailingButton`: O
    static let case6 = PopupAlert(
        message: Text("메세지와 버튼이 있어요"),
        leadingButton: .init(title: Text("확인"),action: {}),
        trailingButton: .init(title: Text("취소"), action: {})
    )
    
    /// - `title`: O
    /// - `message`: X
    /// - `leadingButton`: O
    /// - `trailingButton`: O
    static let case7 = PopupAlert(
        title: Text("제목과 버튼만 있어요"),
        leadingButton: .init(title: Text("확인"),action: {}),
        trailingButton: .init(title: Text("취소"), action: {})
    )
    
    /// 다음과 같은 케이스는 버튼이 생성되지 않습니다.
    /// - `leadingButton` or `trailingButton`은 둘 다 있어야 합니다.
    static let case8 = PopupAlert(
        title: Text("해당 생성자로는 버튼은 하나만 사용할 수 없어요!"),
        leadingButton: .init(title: Text("확인"),action: {})
    )
}
extension String {
    static let mock_message: String = "WI-FI 연결 확인을 꺼두시면 모든 네트워크 상황에서 데이터 상태 확인 없이 동영상 재생/다운로드가 진행됩니다.\n가입하신 데이터 요금제에 따라 통화료가 과도하게 부가될 수 있어, 확인을 켜두시는 것을 권장합니다."
}

#Preview {
    TestView()
}
#endif
