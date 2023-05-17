//
//  View+Extension.swift
//  IGListKitDemo
//
//  Created by Kedar Sukerkar on 17/05/23.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

// https://stackoverflow.com/questions/64301041/swiftui-translucent-background-for-fullscreencover
extension View {
    
    /// Custom FullScreenCover allows to update sheet background color
    func fullScreenCover<Content: View>(isPresented: Binding<Bool>,
                                        sheetBGColor: UIColor,
                                        content: @escaping () -> Content) -> some View {
        fullScreenCover(isPresented: isPresented) {
            ZStack {
                content()
            }
            .background(CustomUIViewRepresentable(bgColor: sheetBGColor))
        }
    }
}

struct CustomUIViewRepresentable: UIViewRepresentable {
    
    let bgColor: UIColor
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = bgColor
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
