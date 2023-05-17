//
//  StoriesView.swift
//  IGListKitDemo
//
//  Created by Ked-27 on 15/05/23.
//

import SwiftUI
import AVFoundation

public struct StoryView: View {
    
    @EnvironmentObject private var viewModel: StoryViewModel
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false   // Improve
    
    // Private properties
    private var selectedIndex: Int
    
    public init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
    }
    
    
    public var body: some View {
        if viewModel.isStoryViewPresented {
            ZStack {
                Color.black.ignoresSafeArea()
                TabView(selection: $viewModel.currentStoryUser) {
                    ForEach($viewModel.stories) { $model in
                        StoryDetailView(model: $model,
                                        isPresented: $viewModel.isStoryViewPresented,
                                        offset: $offset,
                                        isDragging: $isDragging
                        )
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear() {
                startStory()
            }
            .onDisappear() {
                stopVideo()
            }
            .scaleEffect(scaleEffect)
            .offset(getOffset)
        }
    }
    
    private func startStory() {
        viewModel.stories[selectedIndex].isSeen = true
        viewModel.currentStoryUser = viewModel.stories[selectedIndex].id
    }
    
    private func stopVideo() {
        NotificationCenter.default.post(name: .stopVideo, object: nil)
    }
    
    
    // MARK: - Methods
    
    
    private var scaleEffect: CGFloat {
        guard getOffset.height > 0 else {
            return 1
        }
        if isDragging {
            let scale =  1 - ((getOffset.height * 0.001))
            return scale
        } else {
            return 1
        }
    }
    
    var getOffset: CGSize {
        guard offset.height >= 0 else {
            return .zero
        }
        
        var yOffset: CGFloat = 0
        
        if isDragging {
            let friction = offset.height * 0.7
            yOffset = offset.height - friction
        }
        return CGSize(width: 0, height: yOffset)
    }
}
