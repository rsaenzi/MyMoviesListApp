//
//  AuthView.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class AuthView: UIViewController {
    
    var presenter: AuthPresenter!
    fileprivate var submitUrl = ""
    fileprivate var didTapSubmitButton = false
    
    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var webviewTrakt: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelCode.text = "-"
        presenter.getDeviceCode { [weak self] code, url in
            
            guard let `self` = self else {
                return
            }
            
            self.handleResultDeviceCode(code, url)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func handleResultDeviceCode(_ code: String, _ url: String) {
        submitUrl = url
        labelCode.text = code
        load(urlString: url)
    }
    
    fileprivate func load(urlString: String) {
        
        guard let url: URL = URL(string: urlString) else {
            labelCode.text = "X"
            return
        }
        
        let request: URLRequest = URLRequest(url: url)
        webviewTrakt.loadRequest(request)
    }
}

extension AuthView: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        didTapSubmitButton = false
        
        guard let requestUrl: String = request.url?.absoluteString else {
            return true
        }
        
        if navigationType == .formSubmitted, requestUrl.contains("authorize") {
            didTapSubmitButton = true
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if didTapSubmitButton {
            presenter.getToken {_ in
            }
        }
        
        didTapSubmitButton = false
    }
}
