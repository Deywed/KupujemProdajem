
import Foundation

struct AdSummary: Codable {
    let id: Int
    let posted: String
    let location: String
    let title: String
    let price: String
    let currency: String?
    let isFixedPrice: String?
    let thumbnailPath: String?
    let isFollowingAd: Bool?
    let favoriteCount: Int?


    var idString: String {
        return String(id)
    }

    enum CodingKeys: String, CodingKey {
        case id = "ad_id"
        case posted
        case location = "location_name"
        case title = "name"
        case price
        case currency
        case isFixedPrice = "price_fixed"
        case thumbnailPath = "photo1_tmb_300x300"
        case isFollowingAd = "is_following_ad"
        case favoriteCount = "favorite_count"
    }
}
