//
//  Extension + UIImageView.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/23.
//

import UIKit
import Alamofire

extension UIImageView {
    func getImage(urlString: String) -> DataRequest? {
        if let image = ImageCacheManager.shared.getImage(key: urlString) {
            self.image = image
            return nil
        }
        
        let request = AF.request(urlString)
        
        request.response { result in
            guard result.error == nil else {
                return
            }
            
            guard let response = result.response, (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data = result.data,
                  let image = UIImage(data: data) else {
                      return
                  }
            ImageCacheManager.shared.saveImage(key: urlString, image: image)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        return request
    }
    
//    func getImge(urlString: String) -> URLSessionDataTask? {
//        if let image = ImageCacheManager.shared.getImage(key: urlString) {
//            self.image = image
//            return nil
//        }
//        
//        guard let url = URL(string: urlString) else { return nil }
//        
//        let dataTask = URLSession(configuration: .default).dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)  else {
//                return
//            }
//            
//            guard let data = data else {
//                return
//            }
//            
//            guard let image = UIImage(data: data) else { return }
//            
//            DispatchQueue.main.async {
//                self.image = image
//                ImageCacheManager.shared.saveImage(key: urlString, image: image)
//            }
//        }
//        dataTask.resume()
//        
//        return dataTask
//    }
}
