//
//  SampleVC.swift
//  IGListKitDemo
//
//  Created by Koo on 13/03/23.
//

import UIKit
import SwiftUI
import EasyPeasy

class MyViewController: UIViewController {
    
    let bgColor: UIColor
    
    var enableScroll: Bool
    
    
    let dataList = ["First Cell", "World" , "Abc" , "xyz",
                       "qwe", "acz" , "jtyj" , "vxv",
                       "Helegrlo", "erg" , "rtg" , "xyz",
                       "qwe", "vsvds" , "Abgthrc" , "aaxyz",
                       "Hesdfsllo", "vssdvsdv" , "Abcsdfs" , "Last Cell"
    ]
    
    
    
    weak var delegate: MyViewControllerDelegate?
    
    // 1
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = "Hello, UIKit!"
        label.textAlignment = .center
        
        return label
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    
    init(bgColor: UIColor, enableScroll: Bool) {
        self.bgColor = bgColor
        self.enableScroll = enableScroll
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2
        view.backgroundColor = self.bgColor
        // 3
        view.addSubview(label)
        view.addSubview(self.collectionView)
        
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
        
        self.collectionView.easy.layout(
            Width().like(self.view),
            Height().like(self.view),
            CenterX().to(self.view),
            CenterY().to(self.view)
        )
        
        self.collectionView.isScrollEnabled = self.enableScroll
    }
}

extension MyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 50))
        title.text = self.dataList[indexPath.item]
        title.font = UIFont(name: "AvenirNext-Bold", size: 15)
        title.textAlignment = .center
        cell.contentView.addSubview(title)

        title.easy.layout(
            Width().like(cell.contentView),
            Height().like(cell.contentView),
            CenterX().to(cell.contentView),
            CenterY().to(cell.contentView)

        
        )
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            self.delegate?.disableSwiftUIScrolling(true)
        }
    }
    
}













