//
//  ItemPage.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/10.
//

struct ItemPage: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let items: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNo"
        case itemsPerPage = "itemsPerPage"
        case totalCount = "totalCount"
        case offset
        case limit
        case lastPage = "lastPage"
        case hasNext = "hasNext"
        case hasPrev = "hasPrev"
        case items = "pages"
    }
}

struct Item: Codable, ItemAble {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency.RawValue
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
