//
//  HomeViewModel.swift
//  IGListKitDemo
//
//  Created by Kedar-27 on 06/03/23.
//

import UIKit
import KSNetworkManager
import Combine
import KSReachabilityManager

final class HomeViewModel{
    
    //MARK: - Propeties
    let manager: KSNetworkManager
    private var subscriptions = Set<AnyCancellable>()
    private(set) var fetchedListCount = 0
    
    @Published var data = [PostModel]()
    
    
    //MARK: - Initializer
    init() {
        self.manager = KSNetworkManager(baseURL: "https://jsonplaceholder.typicode.com/")
        self.observeNetworkConnection()
    }
    
    //MARK: - Methods
    
    private func observeNetworkConnection(){
        NotificationCenter.default
            .publisher(for: .reachabilityIsConnected)
            .merge(with: NotificationCenter.default
                .publisher(for: .reachabilityIsDisconnected) )
            .compactMap({$0.object as? Bool})
            .sink(receiveCompletion: { _ in
                debugPrint("Completed")
            }, receiveValue: { isConnected in
                if isConnected{
                    if self.data.isEmpty{
                        self.getUserPost()
                    }
                    debugPrint("Connected")
                }else{
                    debugPrint("Disconnected")
                }
            })
            .store(in: &self.subscriptions)
        
    }
    
    
    func deletePost(_ post: PostModel){
        self.data.removeAll(where: {$0 == post})
    }
    
    
    
    
    //MARK: - Network Requests
    func getUserPost(){
        Task{
            guard await KSReachabilityManager.shared.isConnected else{return}
            self.manager.sendRequest(methodType: .get, apiName: "posts?_start=\(self.fetchedListCount)&_limit=10", parameters: nil, headers: nil)?
                .sink(receiveCompletion: { error in
                    debugPrint(error)
                }, receiveValue: { (posts: [PostModel]) in
                    self.fetchedListCount += posts.count
                    self.data.append(contentsOf: posts)
                })
                .store(in: &self.subscriptions)
        }
    }
    
}
