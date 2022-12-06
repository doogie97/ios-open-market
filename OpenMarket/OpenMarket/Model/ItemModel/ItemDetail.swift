//
//  ItemDetail.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/12.
//

struct ItemDetail: Codable, ItemAble {
    var id: Int
    var vendorId: Int
    var name: String
    var thumbnail: String
    var currency: Currency.RawValue
    lazy var currencyIndex: Int? = Currency(rawValue: currency)?.index
    var price: Int
    var description: String?
    var bargainPrice: Int
    var discountedPrice: Int
    var stock: Int
    var createdAt: String
    var issuedAt: String
    var images: [Image]
    var vendor: Vendor
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case name
        case description
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case images
        case vendor = "vendors"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
    struct Image: Codable {
        var id: Int
        var url: String
        var thumbNailURL: String
        var issuedAt: String
        
        private enum CodingKeys: String, CodingKey {
            case id
            case url
            case thumbNailURL = "thumbnail_url"
            case issuedAt = "issued_at"
        }
    }
    
    struct Vendor: Codable {
        var id: Int
        var name: String
        
        private enum CodingKeys: String, CodingKey {
            case id
            case name
        }
    }
}
