//
//  HomeListCVC.swift
//  IGListKitDemo
//
//  Created by Ked-27 on 07/03/23.
//

import UIKit
import EasyPeasy

class HomeListCVC: UICollectionViewCell {
    
    //MARK: - Outlets
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        return label
    }()

    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        self.contentView.addSubview(self.idLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.bodyLabel)
        
        
        self.idLabel.easy.layout(
            Top().to(self.contentView),
            Left(10).to(self.contentView)
        )

        
        self.titleLabel.easy.layout(
            Top().to(self.idLabel),
            Left().to(self.idLabel, .left),
            Width(*0.5).like(self.contentView)
        )
        
        self.bodyLabel.easy.layout(
            Top(5).to(self.titleLabel),
            Width().like(self.contentView),
            Left().to(self.titleLabel, .left),
            Bottom().to(self.contentView)
        )

        
        
    }
    
    func configureCell(id: String,title:String, body: String){
        self.idLabel.text = id
        self.titleLabel.text = title
        self.bodyLabel.text = body
    }
    
}
