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
        
        let myURL = URL(string:"https://ncode.syosetu.com/n0091ip/1/")
        let myRequest = URLRequest(url: myURL!)
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


