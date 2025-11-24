import Foundation

struct AdDetails: Codable {
    let id: String
    let location: String
    let category: String
    let group: String
    let description: String
    let photosPath: String?

    enum CodingKeys: String, CodingKey {
        case id = "ad_id"
        case location = "location_name"
        case category = "cateogry_name"
        case group = "group_name"
        case description
        case photosPath = "photos"
    }
}
