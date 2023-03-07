//
//  HomeVC.swift
//  IGListKitDemo
//
//  Created by Koo on 06/03/23.
//

import UIKit
import IGListKit
import EasyPeasy
import Combine


class HomeVC: UIViewController {


    //MARK: - Outlets
    
    lazy var listCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    lazy var adapter: ListAdapter = {
      return ListAdapter(
      updater: ListAdapterUpdater(),
      viewController: self,
      workingRangeSize: 0)
    }()
    
    //MARK: - Properties
    let viewModel: HomeViewModel
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(viewModel: HomeViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "IGListKit Demo"
        self.viewModel.getUserPost()
        self.setupCollectionView()
        
        self.viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.adapter.performUpdates(animated: true)
        }.store(in: &self.subscriptions)
        
        
    }
    
    private func setupCollectionView(){
        self.adapter.collectionView = self.listCV
        self.adapter.dataSource = self
        self.adapter.delegate = self
        
        self.view.addSubview(self.listCV)
        self.listCV.easy.layout(
            Width().like(self.view.safeAreaLayoutGuide),
            Height().like(self.view.safeAreaLayoutGuide),
            CenterX().to(self.view.safeAreaLayoutGuide),
            CenterY().to(self.view.safeAreaLayoutGuide)
        )

    }
    
    
    
    
    
}

// MARK: - ListAdapterDataSource
extension HomeVC: ListAdapterDataSource, ListAdapterDelegate {
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        guard index == min(self.viewModel.data.count,self.viewModel.fetchedListCount) - 1 else{return}
        self.viewModel.getUserPost()
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {

    }
    
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
      return self.viewModel.data
  }
  
  // 2
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any)
  -> ListSectionController {
    return HomeSectionController()
  }
  
  // 3
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }

}
