//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/31.
//

import UIKit

class ItemDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setTitle(name: String){
        title = name
        navigationItem.setRightBarButton(makeBarButton(), animated: true)
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
