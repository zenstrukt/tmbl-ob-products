import Foundation
import Combine

class APIViewModel: ObservableObject {
    @Published var products: [Product] = []

    func fetchProducts(for bank: String, completion: (() -> Void)? = nil) {
        let bankURLSlug = bank.lowercased()
        let urlString = "https://ob.tmbl.com.au/\(bankURLSlug)/cds-au/v1/banking/products"

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL for \(bank)")
            completion?() // Stop loading if URL is invalid
            return
        }

        products = [] // 🔹 Clear current data for smooth transition

        var request = URLRequest(url: url)
        request.addValue("3", forHTTPHeaderField: "x-v") // 🔹 Required Header

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network Error:", error.localizedDescription)
                    completion?() // Stop loading
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ No HTTP Response")
                    completion?()
                    return
                }

                print("🔹 HTTP Status Code:", httpResponse.statusCode)

                guard httpResponse.statusCode == 200 else {
                    print("❌ API Error - Status Code:", httpResponse.statusCode)
                    completion?()
                    return
                }

                guard let data = data else {
                    print("❌ No Data Received")
                    completion?()
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON Response:", jsonString)
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    self.products = decodedResponse.data.products
                    print("✅ Data Loaded Successfully:", self.products.count, "products")
                } catch {
                    print("❌ JSON Decoding Error:", error)
                }

                completion?() // 🔹 Notify UI that loading is complete
            }
        }.resume()
    }
}
