//
//  SwiftUIView.swift
//  
//
//  Created by Ked-27 on 1.05.2022.
//

import SwiftUI
import AVKit

struct StoryDetailView: View {
    
    
    // MARK: - Properties
    
    
    @EnvironmentObject var storyData: StoryViewModel
    @Binding var model: StoryUIModel
    @Binding var isPresented: Bool
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timerProgress: CGFloat = 0
    @State private var state: MediaState = .notStarted
    @State private var player = AVPlayer()
    @State private var completedLongPress = false
    
    // Gesture Properties
    @Binding var offset: CGSize
    @Binding var isDragging: Bool   // Improve
    @GestureState private var isDetectingLongPress = false
    @GestureState private var isDetectingDragGesture = false
    @GestureState var dragGestureActive = false
    
    var pressAndHoldToPauseGesture: some Gesture {
        LongPressGesture(minimumDuration: 2)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
                print("Long press updating")
            }
            .onEnded { finished in
                self.completedLongPress = finished
                print("long press ended")
            }
    }
    
    var swipeDownToDismissGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                withAnimation {
                    isDragging = true
                    offset = CGSize(width: 0, height: value.translation.height)
                }
                
                
            }
        
            .onEnded { value in
                withAnimation {
                    isDragging = false
                    offset = .zero
                    if value.translation.height > 40 {
                        dismiss()
                    }
                }
                
                
            }
            .updating($dragGestureActive) { value, state, transaction in
                state = true
            }
    }
    
    
    //    var swipeUpForViewsGesture: some Gesture {
    //        DragGesture(minimumDistance: 40, coordinateSpace: .local)
    //            .updating($isDetectingDragGesture){ currentState, gestureState,
    //                transaction in
    //                // Change offset as well scale
    //
    //                print("Drag press updating")
    //            }.onEnded({ value in
    //                if value.translation.height > 40 {
    //                    dismiss()
    //                }
    //            })
    //    }
    
    
    
    // MARK: - Body
    
    
    var body: some View {
        
        GeometryReader { proxy in
            let index = getCurrentIndex()
            ZStack {
                let story = model.stories[index]
                switch story.type {
                    case .image:
                        ImageView(imageURL: story.mediaURL) {
                            start(index: index)
                        }.onAppear() {
                            resetAVPlayer()
                        }
                    case .video:
                        VideoView(videoURL: story.mediaURL, state: $state, player: player) { media, duration in
                            model.stories[index].duration = duration
                            start(index: index)
                            
                        }.onAppear() {
                            playVideo()
                        }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(
                HStack {
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            tapPreviousStory()
                        }
                    
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            tapNextStory()
                        }
                }
            )
            .overlay(
                HStack(spacing: 0) {
                    UserView(isPresented: $isPresented, bundle: model,
                             date: model.stories[index].date)
                    .environmentObject(storyData)
                    
                    CircularProgressBarView(total: model.stories.count, timerProgress: timerProgress, index: index)
                        .frame(width: 42, height: 42)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                    Spacer()
                        .frame(width: 26)
                    
                    Button {
                        print("Show Menu")
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 20)
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: -90))
                    }
                    Spacer()
                        .frame(width: 15)
                }
                ,alignment: .top
            )
            .rotation3DEffect(getAngle(proxy: proxy),
                              axis: (x: 0, y: 1, z: 0),
                              anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                              perspective: 2.5)
        }
        .onAppear(perform: {
            NotificationCenter.default.post(name: .stopVideo, object: nil)
            resetProgress()
        })
        .onReceive(timer) { _ in
            startProgress()
        }
        // Note:- Need to add .simultaneously to detect multiple gesture at same time.
        .gesture(pressAndHoldToPauseGesture.simultaneously(with: swipeDownToDismissGesture))
        .onChange(of: dragGestureActive) { newIsActiveValue in
            if newIsActiveValue == false {
                // Offset is reset due to issue with multifinger
                resetOffset()
            }
        }
    }
    
    
    private func resetOffset() {
        withAnimation {
            offset = .zero
        }
    }
    
}

extension StoryDetailView {
    private func getAngle(proxy: GeometryProxy) -> Angle {
        let rotation: CGFloat = 45
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let degrees = rotation * progress
        return Angle(degrees: degrees)
    }
    
    private func resetProgress() {
        timerProgress = 0
    }
    
    private func getPreviousStory() {
        
        if let first = storyData.stories.first, first.id != model.id {
            
            let bundleIndex = storyData.stories.firstIndex { currentBundle in
                return model.id == currentBundle.id
            } ?? 0
            
            withAnimation {
                storyData.currentStoryUser = storyData.stories[bundleIndex - 1].id
            }
        } else {
            let index = getCurrentIndex()
            if model.stories[index].type == .video {
                NotificationCenter.default.post(name: .stopAndRestartVideo, object: nil)
                resetProgress()
            }
        }
        return
    }
    
    private func getNextStory() {
        let index = getCurrentIndex()
        let story = model.stories[index]
        
        if let last = model.stories.last, last.id == story.id {
            if let lastBundle = storyData.stories.last, lastBundle.id == model.id {
                withAnimation {
                    dismiss()
                }
            } else {
                let bundleIndex = storyData.stories.firstIndex { currentBundle in
                    return model.id == currentBundle.id
                } ?? 0
                
                withAnimation {
                    storyData.currentStoryUser = storyData.stories[bundleIndex + 1].id
                }
            }
        }
    }
    
    private func startProgress() {
        let index = getCurrentIndex()
        if storyData.currentStoryUser == model.id {
            if !model.isSeen {
                model.isSeen = true
            }
            if timerProgress < CGFloat(model.stories.count) {
                if model.stories[index].isReady {
                    getProgressBarFrame(duration: model.stories[index].duration)
                }
            } else {
                updateStory()
            }
        }
    }
    
    private func updateStory(direction: StoryDirectionEnum = .next) {
        if direction == .previous {
            getPreviousStory()
        } else {
            getNextStory()
        }
    }
    
    private func tapNextStory() {
        if (timerProgress + 1) > CGFloat(model.stories.count) {
            //next user
            updateStory()
        } else {
            //next Story
            timerProgress = CGFloat(Int(timerProgress + 1))
        }
    }
    
    private func tapPreviousStory() {
        if (timerProgress - 1) < 0 {
            updateStory(direction: .previous)
        } else {
            timerProgress = CGFloat(Int(timerProgress - 1))
        }
    }
    
    private func start(index: Int) {
        if !model.stories[index].isReady {
            model.stories[index].isReady = true
        }
    }
    
    private func getProgressBarFrame(duration: Double) {
        let calculatedDuration = storyData.getVideoProgressBarFrame(duration: duration)
        timerProgress += (0.01 / calculatedDuration)
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
    
    private func getCurrentIndex() -> Int {
        return min(Int(timerProgress), model.stories.count - 1)
    }
    
    private func resetAVPlayer() {
        player.pause()
        player = AVPlayer()
        
    }
    
    private func playVideo() {
        //player.play()
    }
}
