//
//  HomeView.swift
//  IGListKitDemo
//
//  Created by Ked-27 on 15/05/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: StoryViewModel
    @State var currentIndex = 0
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.stories.indices, id: \.self) { index in
                        let story = viewModel.stories[index]
                        Button {
                            currentIndex = index
                            viewModel.isStoryViewPresented = true
                        } label: {
                            AsyncImage(url: URL(string: story.user.image) , scale: 2) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                        }
                    }
                }
                .padding(15)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
            .navigationTitle("Stories")
            .navigationBarTitleDisplayMode(.automatic)
            .fullScreenCover(isPresented: $viewModel.isStoryViewPresented) {
                StoryView(selectedIndex: currentIndex)
            }
            
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(StoryViewModel())
//    }
//}
