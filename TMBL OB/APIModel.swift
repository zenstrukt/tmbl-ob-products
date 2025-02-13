import Foundation

struct APIResponse: Codable {
    let data: ProductData
}

struct ProductData: Codable {
    let products: [Product]
}

struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let productCategory: String
    let applicationUri: String
    let brand: String
    let brandName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name
        case description
        case productCategory
        case applicationUri
        case brand
        case brandName
    }
}
