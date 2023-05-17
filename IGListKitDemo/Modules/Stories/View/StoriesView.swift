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
                                        isPresented: $viewModel.isStoryViewPresented)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear() {
                startStory()
            }
            .onDisappear() {
                stopVideo()
            }
        }
    }
    
    private func startStory() {
        viewModel.stories[selectedIndex].isSeen = true
        viewModel.currentStoryUser = viewModel.stories[selectedIndex].id
    }
    
    private func stopVideo() {
        NotificationCenter.default.post(name: .stopVideo, object: nil)
    }
}
