//
//  UserView.swift
//  StoryUI (iOS)
//
//  Created by Ked-27 on 29.04.2022.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var storyData: StoryViewModel
    @Binding var isPresented: Bool
    var bundle: StoryUIModel
    var date: String
    
    var body: some View {
        HStack(spacing: Constant.UserView.hStackSpace) {
            CacheAsyncImage(urlString: bundle.user.image)
            VStack(alignment: .leading) {
                Text(bundle.user.name)
                    .fontWeight(.bold)            
                Text(date)
                    .font(.system(size: Constant.UserView.textSize, weight: .thin))
            }
            .foregroundColor(.white)

            Spacer()
        }
        .padding()
    }
}

