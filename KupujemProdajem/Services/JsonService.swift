import Foundation

class JsonService {
    static func loadData() -> AdsResponse? {
        guard let url = Bundle.main.url(forResource: "oglasi", withExtension: "json") else{
            return nil
        }

        do {

            let data = try Data(contentsOf: url)

            let decoder = JSONDecoder()
            let response = try decoder.decode(AdsResponse.self, from: data)
            return response

        } catch {
            print("\(error)")
            return nil
        }
    }
}
