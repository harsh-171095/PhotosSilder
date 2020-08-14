//
//  GlobalTheme.swift
//  SquaredStudent
//
//  Created by webclues on 28/04/20.
//  Copyright © 2020 webclues-mac. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func setTheme(cell:String,cell2:String = "", headerHeight: CGFloat = -1 ) {
        register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        if !cell2.isEmpty {
            register(UINib(nibName: cell2, bundle: nil), forCellReuseIdentifier: cell2)
        }
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        separatorStyle = .none
        if headerHeight > 0 {
        sectionHeaderHeight = UITableView.automaticDimension
        estimatedSectionHeaderHeight = headerHeight
        }
    }
}

//Direction = .horizontal
//responce : [---------------------]
//Direction = .vertical
//responce : [-
//            -
//            -
//            -
//            -
//            -
//            -]
extension UICollectionView {
    
    func setTheme(cell:String, lineSpacing: CGFloat = 10, interitemSpacing: CGFloat = 10, direction: UICollectionView.ScrollDirection = .horizontal, size : CGSize, inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)) {
        register(UINib(nibName: cell, bundle: nil), forCellWithReuseIdentifier: cell)
        backgroundColor = .clear
        let layoutImages = UICollectionViewFlowLayout()
        layoutImages.scrollDirection = direction
        layoutImages.minimumLineSpacing = lineSpacing
        layoutImages.minimumInteritemSpacing = interitemSpacing
        layoutImages.itemSize = size
        layoutImages.sectionInset = inset
        setCollectionViewLayout(layoutImages, animated: true)
    }
}
