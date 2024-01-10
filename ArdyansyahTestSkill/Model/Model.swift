//
//  RegisterModel.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 05/01/24.
//

import Foundation

struct Register: Encodable {
    let name: String
    let email: String
    let password: String
}

struct Login: Encodable {
    let email: String
    let password: String
}

struct ListProduct: Encodable {
    var page: Int?
    var per_page: Int?
    var search: String?
}

struct ProductData: Codable {
    var code: String?
    var message: String?
    var data: DataProduct?
}

struct DataProduct: Codable {
    var items: [Items]?
    var last_page: String?
    var next_page: String?
    var per_page: Int?
    var prev_page: String?
    var total: Int?
}

struct Items: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var total_variant: Int?
    var total_stok: Int?
    var price: Int?
    var image: String?
    var variants: [VariantsData] = []
}

struct VariantsData: Codable {
    var id: Int?
    var image: String?
    var name: String?
    var price: Int?
    var stock: Int?
}


//struct Product: Encodable {
//    var title: String?
//    var description: String?
//    var variants: [Variants] = []
//}

//struct Variants: Encodable {
//    var name: String?
//    var image: String?
//    var price: Int?
//    var stock: Int?
//}
