import SwiftUI

@main
struct LeafLedgerApp: App {
    @StateObject private var store = LeafLedgerStore()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .preferredColorScheme(.dark)
        }
    }
}
