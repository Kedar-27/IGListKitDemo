//
//  HomeViewModel.swift
//  IGListKitDemo
//
//  Created by Koo on 06/03/23.
//

import UIKit
import KSNetworkManager
import Combine

final class HomeViewModel{
    
    let manager: KSNetworkManager
    private var subscriptions = Set<AnyCancellable>()
    private(set) var fetchedListCount = 0

    @Published var data = [PostModel]()
    
    init() {
        self.manager = KSNetworkManager(baseURL: "https://jsonplaceholder.typicode.com/")
    }
    
    //MARK: - Methods
    func deletePost(_ post: PostModel){
        self.data.removeAll(where: {$0 == post})
    }
    
    
    
    //MARK: - Network Requests
    func getUserPost(){
        
        self.manager.sendRequest(methodType: .get, apiName: "posts?_start=\(self.fetchedListCount)&_limit=10", parameters: nil, headers: nil)?
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { (posts: [PostModel]) in
                self.fetchedListCount += posts.count
                self.data.append(contentsOf: posts)
            })
            .store(in: &self.subscriptions)
    }
    
}
