//
//  HomeSectionController.swift
//  IGListKitDemo
//
//  Created by Kedar-27 on 07/03/23.
//

import UIKit
import IGListKit

class HomeSectionController: ListSectionController {

    var model: PostModel?
    
    override init() {
      super.init()
      inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
          return CGSize(width: collectionContext!.containerSize.width, height: 140)
      }

      override func cellForItem(at index: Int) -> UICollectionViewCell {
          guard let cell = self.collectionContext?.dequeueReusableCell(of: HomeListCVC.self,
                                                                  for: self,
                                                                       at: index) as? HomeListCVC , let model = model else {
              assertionFailure()
              return UICollectionViewCell()
          }
          cell.configureCell(id: String(model.id),title: model.title, body: model.body )
          return cell
      }
    
    override func didUpdate(to object: Any) {
        self.model = object as? PostModel
    }
    
    override func didSelectItem(at index: Int) {
        guard let post = self.model, let viewModel = (self.viewController as? HomeVC)?.viewModel else{return}
        viewModel.deletePost(post)
    }
    

}
