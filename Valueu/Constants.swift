import Foundation

enum Constants {

    static let appURL = URL(string: "https://apps.apple.com/app/id6754287243")!
    static let termsOfUse = URL(string: "https://docs.google.com/document/d/e/2PACX-1vRvbNVOxwQV4EomISDAOlvZ1xXzFERcb5no8jBj7BxSyitcs33aIa7Kyj1PWyqAOGdgAJgn9-Essote/pub")!
    static let privacyPolicy = URL(string: "https://docs.google.com/document/d/e/2PACX-1vRvbNVOxwQV4EomISDAOlvZ1xXzFERcb5no8jBj7BxSyitcs33aIa7Kyj1PWyqAOGdgAJgn9-Essote/pub")!
    static var shareMessage: String {
        """
        Find joy in everyday moments:
        \(appURL.absoluteString)
        """
    }
    static var shareItems: [Any] { [shareMessage, appURL] }
}
