//
//  ProgressView.swift
//  StoryUI (iOS)
//
//  Created by Ked-27 on 29.04.2022.
//

import SwiftUI

struct ProgressBarView: View {
    var timerProgress: CGFloat
    var index: Int
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let progress = timerProgress - CGFloat(index)
            let perfectProgress = min(max(progress, 0), 1)

            Capsule()
                .fill(.gray.opacity(0.5))
                .overlay (
                    Capsule()
                        .fill(.white)
                        .frame(width: width * perfectProgress)

                    ,alignment: .leading
                )
        }
        .frame(height: Constant.progressBarHeight)
    }
}

struct CircularProgressBarView: View {
    
    
    // MARK: - Properties
    
    
    let total: Int
    var timerProgress: CGFloat
    var index: Int
    @State var lineWidth: CGFloat = 5
    @State var color: Color = .white
    
    var body: some View {
        let progress = timerProgress //- CGFloat(index)
       // let completed = min(max(progress, 0), 1)
        
        CircularProgressBarBackgroundView(lineWidth: lineWidth, total: total)
            .overlay(alignment: .top) {
                CircularProgressBarProgressView(lineWidth: lineWidth, color: color, total: total, completed: progress)
            }
            .overlay(alignment: .center) {
                Text("\(index + 1)/\(total)")
                    .foregroundColor(.white)
            }
    }
}

fileprivate struct CircularProgressBarBackgroundView: View {
    
    
    // MARK: - Properties
    
    
    @State var lineWidth: CGFloat = 16
    let total: Int
    var dashColor = Color.white.opacity(0.18)
    var shortDashSize: CGFloat { lineWidth * 1.2 }
    
    
    // MARK: - Body
    
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .stroke(dashColor,
                        style: StrokeStyle(
                            lineWidth: lineWidth / 1.6,
                            lineCap: .round,
                            lineJoin: .miter,
                            miterLimit: 0,
                            dash: [
                                longDashSize(circleWidth: geometry.size.width),
                                shortDashSize
                            ],
                            dashPhase: 0))
                .rotationEffect(.degrees(-90))
        }
        .padding(lineWidth/2)
    }
    
    
    // MARK: - Methods
    
    
    func longDashSize(circleWidth: CGFloat) -> CGFloat {
        .pi * circleWidth / CGFloat(total) - shortDashSize
    }
    
}

fileprivate struct CircularProgressBarProgressView: View {
    
    
    // MARK: - Properties
    
    
    @State var lineWidth: CGFloat = 16
    @State var color: Color = .green
    let total: Int
    let completed: CGFloat
    var shortDashSize: CGFloat { lineWidth * 1.2 }
    var progress: CGFloat {
        completed / CGFloat(total)
    }
    
    
    // MARK: - Body
    
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color,
                        style: StrokeStyle(
                            lineWidth: lineWidth / 1.6,
                            lineCap: .round,
                            lineJoin: .miter,
                            miterLimit: 0,
                            dash: [
                                longDashSize(circleWidth: geometry.size.width),
                                shortDashSize
                            ],
                            dashPhase: 0
                        ))
                .rotationEffect(.degrees(-90))
            
        }
        .padding(lineWidth / 2)
        
    }
    
    
    // MARK: - Methods
    
    
    func longDashSize(circleWidth: CGFloat) -> CGFloat {
        .pi * circleWidth / (CGFloat(total) - 0.02) - shortDashSize
    }
    
}
