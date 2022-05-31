//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/31.
//

import UIKit

class ItemDetailViewController: UIViewController {
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
