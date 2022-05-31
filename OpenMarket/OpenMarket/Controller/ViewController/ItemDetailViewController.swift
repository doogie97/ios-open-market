//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/31.
//

import UIKit

class ItemDetailViewController: UIViewController {
    @IBOutlet weak var itemImageCollectionView: UICollectionView!
    @IBOutlet weak var imageNumberLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    private let networkHandler = NetworkHandler()
    private var itemDetail: ItemDetail? = nil {
        didSet {
            DispatchQueue.main.async {
                self.setIntialView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getItemDetail(id: Int) {
        let itemDetailAPI = ItemDetailAPI(id: id)
        networkHandler.request(api: itemDetailAPI) { data in
            switch data {
            case .success(let data):
                guard let itemDetail = try? DataDecoder.decode(data: data, dataType: ItemDetail.self) else { return }
                self.itemDetail = itemDetail
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setIntialView() {
        itemImageCollectionView.dataSource = self
        itemImageCollectionView.delegate = self
        itemImageCollectionView.register(UINib(nibName: "\(DetailImageCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(DetailImageCell.self)")
        setCollectionViewLayout()
        
        navigationItem.setRightBarButton(makeBarButton(), animated: true)
        guard let itemDetail = itemDetail else { return }
        
        title = itemDetail.name
        itemNameLabel.text = itemDetail.name
        
        if itemDetail.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        } else {
            stockLabel.text = "남은 수량 : " + itemDetail.stock.description
            stockLabel.textColor = .systemGray
        }
        
        if itemDetail.price == 0 {
            priceLabel.isHidden = true
        } else {
            let price = "\(itemDetail.currency) \(itemDetail.price.description)"
            priceLabel.attributedText = price.strikethrough()
        }
        
        discountedPriceLabel.text = "\(itemDetail.currency) \(itemDetail.discountedPrice.description)"
        descriptionTextView.text = itemDetail.description
        myActivityIndicator.stopAnimating()
    }
    
    @objc private func touchEditButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let inAlert = UIAlertController(title: "비밀번호를 입력해 주세요", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            inAlert.addAction(yesAction)
            inAlert.addTextField()
            self.present(inAlert, animated: true, completion: nil)
        }
        let cancelAction = (UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

// about View
extension ItemDetailViewController {
    private func makeBarButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(touchEditButton))
        barButton.title = title
        return barButton
    }
}

extension ItemDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDetail?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DetailImageCell.self)", for: indexPath) as? DetailImageCell else { return DetailImageCell() }
        
        cell.configureImage(url: itemDetail?.images[indexPath.row].url ?? "")
        
        return cell
    }
}

extension ItemDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageNumberLabel.text = "\(indexPath.row + 1)/\(itemDetail?.images.count ?? 0)"
    }
}

extension ItemDetailViewController {
    private func setCollectionViewLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: itemSize.widthDimension, heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        itemImageCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}
