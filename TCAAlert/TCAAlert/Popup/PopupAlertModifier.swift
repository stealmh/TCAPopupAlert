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
                if self.item != nil {
                    /// 흐려지는 배경색을 설정할 수 있습니다.
                    Color.black.opacity(0.1)
                        .onTapGesture { withAnimation { self.item = nil } }
                    /// 전환 애니메이션 처리
                        .transition(.opacity.animation(.linear(duration: 0.4)))
                        .ignoresSafeArea()
                }
            }
            .overlay {
                if let menu = self.item {
                    VStack(alignment: .leading, spacing: 0) {
                        if let title = menu.title {
                            title
                                .bold()
                        }
                        
                        if let message = menu.message {
                            message
                                .font(.callout)
                                .padding(.top, 5)
                                .padding(.bottom, 10)
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
                            
                            Button(action: { fb.action() }) {
                                HStack {
                                    Spacer()
                                    fb.title
                                        .foregroundStyle(.white)
                                        .bold()
                                    Spacer()
                                }
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 7)
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        
                    }
                    .padding(20)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                    }
                    .padding(.horizontal, 20)
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
struct BottomMenu_Classic_Previews: PreviewProvider {
    struct TestView: View {
        @State var menu: PopupAlert? = Self.sampleMenu
        
        var body: some View {
            Button("Present") { withAnimation { self.toggle() } }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .alert(item: self.$menu.animation())
        }
        
        func toggle() {
            self.menu = self.menu == nil ? Self.twoButtonMenu : nil
        }
        
        static let sampleMenu = PopupAlert(
            title: Text("WIFI 연결확인"),
            message: Text("WI-FI 연결 확인을 꺼두시면 모든 네트워크 상황에서 데이터 상태 확인 없이 동영상 재생/다운로드가 진행됩니다.\n가입하신 데이터 요금제에 따라 통화료가 과도하게 부가될 수 있어, 확인을 켜두시는 것을 권장합니다."),
            footerButton: .init(
                title: Text("확인"),
                action: {}
            )
        )
        
        static let twoButtonMenu = PopupAlert(
            title: Text("불러오기"),
            message: Text("임시 저장된 내용을 불러오시겠습니까?"),
            leadingButton: .init(title: Text("확인"),action: {}),
            trailingButton: .init(title: Text("취소"), action: {})
        )
    }
    
    static var previews: some View {
        TestView()
    }
}
#endif
