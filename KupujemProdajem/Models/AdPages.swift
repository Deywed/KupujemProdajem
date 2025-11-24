struct AdPage: Codable {
    let totalPages: Int
    let currentPage: Int
    let ads: [AdSummary]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "pages"
        case currentPage = "page"
        case ads
    }
}
