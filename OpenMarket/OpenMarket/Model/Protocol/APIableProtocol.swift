//
//  APIableProtocol.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/16.
//
import Foundation
import Alamofire

protocol APIable {
    var host: String { get }
    var path: String { get }
    var params: [String : String]? { get }
    var method: HTTPMethod { get }
    var itemComponents: ItemComponents? { get }
    var password: String? { get }
}

