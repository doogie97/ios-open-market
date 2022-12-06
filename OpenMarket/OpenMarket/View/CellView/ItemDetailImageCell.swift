//
//  ItemDetailCell.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/06/01.
//

import UIKit
import Alamofire

final class ItemDetailImageCell: UICollectionViewCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    private var dataTask: DataRequest?
    
    func configureImage(url: String) {
        dataTask = itemImageView.getImage(urlString: url)
    }
}
