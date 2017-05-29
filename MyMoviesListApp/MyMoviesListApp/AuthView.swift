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
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var webviewTrakt: UIWebView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonReload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = LanguageString.authTitle.localize()
        buttonBack.setTitle(LanguageString.back.localize(), for: .normal)
        buttonReload.setTitle(LanguageString.reload.localize(), for: .normal)
        
        activityLoading.isHidden = true
        
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
        webviewTrakt.becomeFirstResponder()
    }
    
    @IBAction func onTapBack(_ sender: UIButton, forEvent event: UIEvent) {
        if activityLoading.isHidden == true {
            webviewTrakt.goBack()
        }
    }
    
    @IBAction func onTapReload(_ sender: UIButton, forEvent event: UIEvent) {
        if activityLoading.isHidden == true {
            webviewTrakt.reload()
        }
    }
    
    fileprivate func handleResultDeviceCode(_ code: String, _ url: String) {
        submitUrl = url
        labelCode.text = code
        load(urlString: url)
    }
    
    fileprivate func load(urlString: String) {
        
        guard let url: URL = URL(string: urlString) else {
            labelCode.text = ""
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
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityLoading.isHidden = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityLoading.isHidden = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        activityLoading.isHidden = true
        
        if didTapSubmitButton {
            presenter.getToken()
        }
        
        didTapSubmitButton = false
    }
}
