import UIKit
import WebKit
import SwiftUI

class NovelViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: UrlModel().url)
        webView.load(myRequest)
    }
}

struct NovelViewControllerRepresentable: UIViewControllerRepresentable{
    
    func makeUIViewController(context: Context) -> some NovelViewController {
        return NovelViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

#Preview {
    NovelViewController()
}


