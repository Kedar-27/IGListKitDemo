//
//  ScrollView+Extensions.swift
//  IGListKitDemo
//
//  Created by Koo on 13/03/23.
//

import SwiftUI
import Combine

/// View that observes its position within a given coordinate space,
/// and assigns that position to the specified Binding.
struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

private extension PositionObservingView {
    enum PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }

        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            // No-op
        }
    }
}

/// Specialized scroll view that observes its content offset (scroll position)
/// and assigns it to the specified Binding.
struct OffsetObservingScrollView<Content: View>: View {
    var axes: Axis.Set = [.vertical]
    var showsIndicators = false
    @Binding var offset: CGPoint
    @Binding var isScrollEnabled: Bool
    @ViewBuilder var content: () -> Content

    private let coordinateSpaceName = UUID()

    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            PositionObservingView(
                coordinateSpace: .named(coordinateSpaceName),
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        offset = CGPoint(
                            x: -newOffset.x,
                            y: -newOffset.y
                        )
                    }
                ),
                content: content
            )
        }//.scrollDisabled(!self.isScrollEnabled)
        .coordinateSpace(name: coordinateSpaceName)
    }
}


struct MyView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MyViewController
    
    
    //MARK: - Data Injections
    let bgColor: UIColor
    
    @Binding var isScrollEnabled: Bool
    
    
    func makeUIViewController(context: Context) -> MyViewController {
        let vc = MyViewController(bgColor: bgColor,enableScroll: self._isScrollEnabled.wrappedValue)
        // Do some configurations here if needed.
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MyViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
        
        uiViewController.enableScroll = self.isScrollEnabled
        uiViewController.collectionView.isScrollEnabled = self.isScrollEnabled
    }
    
    // this will be the delegate of the view controller, it's role is to allow
    // the data transfer from UIKit to SwiftUI
    class Coordinator: MyViewControllerDelegate {
        let isScrollEnabled: Binding<Bool>
        
        init(isScrollEnabled: Binding<Bool>) {
            self.isScrollEnabled = isScrollEnabled
        }
        
        func disableSwiftUIScrolling(_ value: Bool) {
            self.isScrollEnabled.wrappedValue = !value
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isScrollEnabled: $isScrollEnabled)
    }

    
    
    
}

protocol MyViewControllerDelegate: AnyObject {
    func disableSwiftUIScrolling(_ value: Bool)
}
