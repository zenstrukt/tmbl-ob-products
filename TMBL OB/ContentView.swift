import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = APIViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var selectedBank = "TMBank"
    @State private var isLoading = false

    let banks = ["TMBank", "UniBank", "FMBank", "HPBank", "Hiver"]

    var body: some View {
        NavigationView {
            ZStack {
                Color(isDarkMode ? .black : .white)
                    .edgesIgnoringSafeArea(.all)

                if isLoading {
                    ProgressView("Loading Products...")
                        .foregroundColor(isDarkMode ? .white : .black)
                        .scaleEffect(1.5)
                } else {
                    List(viewModel.products) { product in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product.name)
                                .font(.headline)
                                .foregroundColor(isDarkMode ? .white : .black)

                            Text(product.description)
                                .font(.subheadline)
                                .foregroundColor(isDarkMode ? .gray : .black)

                            HStack {
                                Text("Category: \(formatCategory(product.productCategory))")
                                    .font(.caption)
                                    .foregroundColor(.blue)

                                Spacer()

                                Link("Apply", destination: URL(string: product.applicationUri)!)
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(5)
                        .listRowBackground(isDarkMode ? Color.black : Color.white)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Bank", selection: $selectedBank) {
                        ForEach(banks, id: \.self) { bank in
                            Text(bank).tag(bank)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedBank) { newBank in // ✅ iOS 17+ Compliant
                        switchBank()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                        updateNavBarAppearance()
                    }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .yellow : .blue)
                    }
                }
            }
            .onAppear {
                print("🔄 Fetching products for \(selectedBank)...")
                switchBank()
                updateNavBarAppearance()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    func switchBank() {
        isLoading = true
        viewModel.fetchProducts(for: selectedBank) {
            isLoading = false
        }
    }

    func formatCategory(_ category: String) -> String {
        switch category {
        case "CRED_AND_CHRG_CARDS": return "Credit Cards"
        case "TRANS_AND_SAVINGS_ACCOUNTS": return "Savings & Transactions"
        case "TERM_DEPOSITS": return "Term Deposits"
        case "RESIDENTIAL_MORTGAGES": return "Home Loans"
        case "PERS_LOANS": return "Personal Loans"
        default: return category.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }

    func updateNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = isDarkMode ? UIColor.black : UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: isDarkMode ? UIColor.white : UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: isDarkMode ? UIColor.white : UIColor.black]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
