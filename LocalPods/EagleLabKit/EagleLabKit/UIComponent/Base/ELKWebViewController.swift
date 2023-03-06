//
//  ELKWebViewController.swift
//  TCLHome
//
//  Created by lidan on 2022/1/19.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import MJRefresh
import NXNavigationExtension
import SnapKit
import UIKit
import WebKit

class ELKWebViewController: ELKViewController, ELKWebViewBuilder {
    var userInterface: ELKHybridUserInterface = .init()
    /// 返回按钮图片
    var backButtonImage: UIImage?

    /// 关闭按钮图片
    var closeButtonImage: UIImage?

    var urlString = ""

    /// 脚本注入的配置
    func buildConfiguration() -> ELKWebViewConfiguration {
        return ELKWebViewConfiguration.configuration(.defaultConfiguration)
    }

    ///  协议的配置
    func buildBridge(webView: WKWebView) -> ELKAbstractJavaScriptBridge {
        return ELKJavaScriptBridge(webView: webView)
    }

    private(set) lazy var webView: ELKWebView = {
        let configuration = buildConfiguration()
        let webView = ELKWebView(frame: .zero, configuration: configuration)
        let bridge = buildBridge(webView: webView)
        // webView
        webView.bridge = bridge
        webView.elkNavigationDelegate = self
        webView.elkUIDelegate = self
        webView.scrollView.delegate = self
        webView.delegate = self
        // 用户脚本注入和UserAgent设置, 还有注册接口
        webView.userConfigurate()
        return webView
    }()

    private(set) lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor(hex: 0xF4F5F7)
        progressView.progressTintColor = UIColor(hex: 0x4183FF)
        progressView.isHidden = true
        return progressView
    }()

    private lazy var customBackItem: UIBarButtonItem = {
        let widthAndHeight = CGFloat(36.0)
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 0, y: 0, width: widthAndHeight, height: widthAndHeight)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.contentHorizontalAlignment = .leading
        backButton.addTarget(self, action: #selector(clickBackButton(_:)), for: .touchUpInside)

        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: backButton.frame.width, y: 0, width: widthAndHeight, height: widthAndHeight)
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.contentHorizontalAlignment = .leading
        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), for: .touchUpInside)

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: closeButton.frame.maxX, height: widthAndHeight))
        customView.addSubview(backButton)
        customView.addSubview(closeButton)

        return UIBarButtonItem(customView: customView)
    }()

    /// 分享按钮
    lazy var shareButtonItem: UIBarButtonItem = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ShareNavIcon"), for: .normal)
        button.addTarget(self, action: #selector(clickShareButton(_:)), for: .touchUpInside)
        var barItem = UIBarButtonItem(customView: button)
        return barItem
    }()

    lazy var refreshButtonItem: UIBarButtonItem = {
        var button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        button.setImage(UIImage(named: "start_over_icon"), for: .normal)
        button.addTarget(self, action: #selector(clickRefreshButton(_:)), for: .touchUpInside)
        var barItem = UIBarButtonItem(customView: button)
        return barItem
    }()

    private var originalBackItem: UIBarButtonItem?
    private var titleObservation: NSKeyValueObservation?
    private var estimatedProgressObservation: NSKeyValueObservation?
    private var isLoadingProgressObservation: NSKeyValueObservation?
    private var canGoBackProgressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        addViewContents()
        addViewConstraints()
        setupViewContents()

        // 加载页面
        webView.loadPage(urlString)

        // 设置导航栏高度
        webView.send(statusBar: Float(UIScreen.main.elk.statusBarHeight))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 停止网页媒体
        webView.pauseVideo()
    }
}

extension ELKWebViewController {
    private var useProgressView: Bool {
        return userInterface.progressPosition == .viewTop ||
            userInterface.progressPosition == .statusBarBottom ||
            userInterface.progressPosition == .navigationBarBottom
    }

    private var useLoadingView: Bool {
        return userInterface.progressPosition == .loading
    }

    private func addViewContents() {
        view.addSubview(webView)
        addViewContents(withProgressPosition: userInterface.progressPosition)
    }

    private func addViewConstraints() {
        addViewConstraints(withProgressPosition: userInterface.progressPosition)
        addViewConstraints(webViewTopLeading: userInterface.webViewTopLeading)
    }

    private func setupViewContents() {
        backButtonImage = UIImage(named: "NavigationBarBackButtonBlack")
        closeButtonImage = UIImage(named: "NavigationBarCloseButtonBlack")

        progressView.progressTintColor = userInterface.progressTintColor
        progressView.trackTintColor = userInterface.progressTrackTintColor

        view.backgroundColor = userInterface.backgroundColor
        if userInterface.isPullRefresh {
            webView.scrollView.mj_header = MJRefreshHeader(refreshingBlock: { [weak self] in
                self?.reloadWebView()
            })
        }

        originalBackItem = navigationItem.leftBarButtonItem

        addObservers()

        updateRightButtonItem()
    }

    private func addViewContents(withProgressPosition position: ELKHybridUserInterface.ProgressPosition) {
        switch position {
        case .statusBarBottom, .navigationBarBottom, .viewTop:
            view.addSubview(progressView)
        default:
            progressView.removeFromSuperview()
        }
    }

    private func addViewConstraints(withProgressPosition position: ELKHybridUserInterface.ProgressPosition) {
        switch position {
        case .statusBarBottom, .navigationBarBottom, .viewTop:
            progressView.snp.makeConstraints { make in
                make.height.equalTo(2.0)
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)

                if position == .statusBarBottom {
                    progressView.snp.makeConstraints { make in
                        make.top.equalTo(view.snp.top).offset(UIScreen.main.elk.statusBarHeight)
                    }
                }

                if position == .navigationBarBottom {
                    progressView.snp.makeConstraints { make in
                        make.top.equalTo(view.snp.top).offset(self.elk.navigationBarVisualHeight)
                    }
                }

                if position == .viewTop {
                    progressView.snp.makeConstraints { make in
                        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    }
                }
            }
        default:
            break
        }
    }

    func addViewConstraints(webViewTopLeading: ELKHybridUserInterface.ELKWebViewTopLeading) {
        switch webViewTopLeading {
        case .zero:
            // 有导航栏的时候是导航栏底部，没有的时候是顶部
            if (navigationController?.navigationBar) != nil {
                webView.snp.makeConstraints { make in
                    make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                    make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)

                    if userInterface.progressPosition == .viewTop {
                        make.top.equalTo(progressView.snp.bottom)
                    } else if self.nx_translucentNavigationBar {
                        make.top.equalTo(view.snp.top)
                    } else {
                        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    }
                }
            } else {
                webView.snp.makeConstraints { make in
                    make.top.equalTo(view.snp.top)
                    make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                    make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                }
            }
        case .statusTrailing:
            // 不存在有导航栏的情况
            webView.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top).offset(UIScreen.main.elk.statusBarHeight)
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }

    private func addObservers() {
        titleObservation = webView.observe(\.title, options: .new) { [weak self] webView, _ in
            guard let self = self else { return }
            if self.userInterface.isAutomaticLoadTitle {
                self.navigationItem.title = webView.title
            }
        }

        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, _ in
            guard let self = self else { return }
            debugPrint("webView(_ 加载框 estimatedProgress: \(webView.estimatedProgress)")
            if self.useProgressView {
                let animated = Float(webView.estimatedProgress) > self.progressView.progress
                self.progressView.setProgress(Float(webView.estimatedProgress), animated: animated)
            }

            if self.useLoadingView {
                debugPrint("加载框 estimatedProgress: \(webView.estimatedProgress)")
            }
        }

        isLoadingProgressObservation = webView.observe(\.isLoading, options: .new) { [weak self] webView, _ in
            guard let self = self else { return }

            self.progress(isLoading: webView.isLoading)
        }

        canGoBackProgressObservation = webView.observe(\.canGoBack, options: .new, changeHandler: { [weak self] webView, _ in
            guard let self = self else { return }
            if self.userInterface.isShowCloseButton {
                self.navigationItem.leftBarButtonItem = webView.canGoBack ? self.customBackItem : self.originalBackItem
            } else {
                self.navigationItem.leftBarButtonItem = self.originalBackItem
            }
        })
    }
}

@objc
extension ELKWebViewController {
    private func clickBackButton(_ button: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.nx_popViewController(animated: true)
        }
    }

    private func closeButtonClick(_ button: UIButton) {
        closeViewController()
    }

    func clickShareButton(_ button: UIButton) {
        debugPrint("点击分享")
    }

    func clickRefreshButton(_ button: UIButton) {
        debugPrint("刷新点击")
        webView.clearMsg()
    }
}

@objc
extension ELKWebViewController {
    /// 点击 X 按钮
    func closeViewController() {
        guard let navigationController = navigationController else { return }
        if navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            navigationController.dismiss(animated: true, completion: nil)
        }
    }

    /// 点击返回按钮
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.nx_popViewController(animated: true)
        }
    }

    func reloadWebView() {
        if userInterface.isPullRefresh {
            webView.reload()
        }
    }

    func showAgreementErrorPage() {
        navigationItem.title = ""
        let image = UIImage(named: "ErrorNetwork")
        let title = "network_request_failed".elk.localized
        let subtitle = "please_check_your_network_reload".elk.localized
        let buttonText = "retry".elk.localized
        let model = ELKDefaultPageModel(image: image,
                                        title: title,
                                        subtitle: subtitle,
                                        buttonText: buttonText)
        elk.showDefaultPage(model: model) { [weak self] in
            self?.reloadWebView()
        }
    }

    func progress(isLoading: Bool) {
        debugPrint("webView(_ progress(isLoading:")
        if useProgressView {
            progressView.isHidden = !isLoading
        }

        if useLoadingView {
            if isLoading {
                ELKPopover.popProgress(view: view, text: "")
            } else {
                ELKPopover.removeProgress(superView: view)
            }
        }
    }
}

extension ELKWebViewController: WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint("webView(_ decidePolicyFor")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        debugPrint("webView(_ WKNavigationResponse")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        // 移除网页长按复制功能，部分机型长按会出现奔溃问题，还可以优化网页的用户体验
        if let aClass = NSClassFromString("WKContentView") {
            for subview in webView.scrollView.subviews where subview.isKind(of: aClass) {
                subview.gestureRecognizers?
                    .map { $0 }
                    .filter { $0 is UILongPressGestureRecognizer }
                    .forEach { subview.removeGestureRecognizer($0) }
            }
        }
        // 停止刷新
        stopRefresh()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // 停止刷新
        stopRefresh()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 停止刷新
        stopRefresh()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // 停止刷新
        stopRefresh()
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
}

extension ELKWebViewController: NXNavigationControllerDelegate {
    func nx_navigationController(_ navigationController: UINavigationController, willPop viewController: UIViewController, interactiveType: NXNavigationInteractiveType) -> Bool {
        if webView.canGoBack {
            webView.goBack()
            return false
        }

        if userInterface.isShowBackAlert {
            webView.changeState()
            return false
        } else {
            return true
        }
    }

    override var nx_translucentNavigationBar: Bool {
        return userInterface.isTranslucentNavigationBar
    }
}

extension ELKWebViewController: ELKWebViewDelegate {
    func webView(webView: ELKAbstractWebView?, tabBarHidden: Bool) { // 是否隐藏底部栏
        userInterface.isTabarHidden = tabBarHidden
    }

    func webView(webView: ELKAbstractWebView?, shareButtonHidden: Bool) {
        userInterface.rightItemType = shareButtonHidden ? .share : .none
        updateRightButtonItem()
    }

    func webView(closeWebView: ELKAbstractWebView?) {
        closeViewController()
    }

    func webView(backForwardWebView: ELKAbstractWebView?) {
        goBack()
    }
}

extension ELKWebViewController {
    private func stopRefresh() {
        if let header = webView.scrollView.mj_header {
            header.endRefreshing()
        }
    }

    private func updateRightButtonItem() {
        switch userInterface.rightItemType {
        case .none:
            navigationItem.rightBarButtonItem = nil
        case .share:
            navigationItem.rightBarButtonItem = shareButtonItem
        case .refresh:
            navigationItem.rightBarButtonItem = refreshButtonItem
        }
    }
}
