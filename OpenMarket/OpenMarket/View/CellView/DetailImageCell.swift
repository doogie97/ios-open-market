//
//  DetailImageCell.swift
//  OpenMarket
//
//  Created by 백민성 on 2022/05/31.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    private var dataTask: URLSessionDataTask?
    
    func configureImage(url: String) {
        dataTask = itemImageView.getImge(urlString: url)
    }
}
