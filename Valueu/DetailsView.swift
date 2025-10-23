import SwiftUI

struct DetailsView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AppManager {

        return AppManager(url: url)
    }

    func updateUIViewController(
        _ uiViewController: AppManager,
        context: Context
    ) {

    }
}
