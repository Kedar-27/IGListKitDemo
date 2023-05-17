//
//  StoryViewModel.swift
//  IGListKitDemo
//
//  Created by Kedar Sukerkar on 15/05/23.
//

import Foundation

final class StoryViewModel: ObservableObject {
    
    @Published var stories = [
        StoryUIModel(user: StoryUser(name: "Rooney", image: "https://resources.premierleague.com/premierleague/photos/players/250x250/p13017.png"), stories: [
            Story(mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", date: "30 min ago", type: .video),
            Story(mediaURL: "https://image.tmdb.org/t/p/original//pThyQovXQrw2m0s9x82twj48Jq4.jpg", date: "1 hour ago", type: .image),
            Story(mediaURL: "https://image.tmdb.org/t/p/original/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg", date: "12 hour ago", type: .image)
        ]),
        StoryUIModel(user: StoryUser(name: "Berbatov", image: "https://resources.premierleague.com/premierleague/photos/players/250x250/p8595.png"), stories: [
            Story(mediaURL: "https://picsum.photos/id/15/1920/1080", date: "12 hour ago", type: .image),
            Story(mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4", date: "30 min ago", type: .video)
        ]),
        StoryUIModel(user: StoryUser(name: "Juan Mata", image: "https://pbs.twimg.com/media/FRx_CxXX0AAbeSH.jpg"), stories: [
            Story(mediaURL: "https://images.unsplash.com/photo-1600716051809-e997e11a5d52?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8c2FtcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", date: "12 hour ago", type: .image),
            Story(mediaURL: "https://player.vimeo.com/external/465329423.sd.mp4?s=0ad5bfbfa8fb5ba790482e4803eebb0654f60850&profile_id=164&oauth2_token_id=57447761", date: "30 min ago", type: .video)
        ]),
    ]
    
    @Published var isStoryViewPresented: Bool = false
    @Published var currentStoryUser: String = ""
    
    func getVideoProgressBarFrame(duration: Double) -> Double {
        return duration * 0.1 // convert any second to  between 0 - 1 second
    }
}
