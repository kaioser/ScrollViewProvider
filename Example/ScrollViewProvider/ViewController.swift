//
//  ViewController.swift
//  ScrollViewProvider
//
//  Created by yxkkk on 05/18/2023.
//  Copyright (c) 2023 yxkkk. All rights reserved.
//

import UIKit
import ScrollViewProvider
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 80)
        button.setTitle("pop", for: .normal)
        button.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func popAction() {
        
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        // 这种sheet可以用在很多地方，比如底部评论列表、评论field、评论回复列表等
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                                sheet.detents = [.medium(), .large()]
                //                sheet.selectedDetentIdentifier = .large
                
                // medium控制器内容可滑动
//                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                
                // 去除背景半透明阴影
                //                sheet.largestUndimmedDetentIdentifier = .medium
                
                
//                if #available(iOS 16.0, *) {
//                    sheet.detents = [.medium(), .large(), .custom(resolver: { context in
//                        100
//                    })]
//                } else {
                    // Fallback on earlier versions
//                }
                //                sheet.selectedDetentIdentifier = .large
                
                
                // 改变圆角
//                sheet.preferredCornerRadius = 50
                
                // 顶部bar
//                sheet.prefersGrabberVisible = true
            }
        }
        
        // 禁止手势拖动dismiss
//        nav.isModalInPresentation = true
        
        present(nav, animated: true)
    }
}

fileprivate class TempController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Temp"
        view.backgroundColor = .white
    }
}


fileprivate class TempControllerAir: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "代码更改模式", style: .plain, target: self, action: #selector(changeAction))
        navigationItem.title = "Temp"
        view.backgroundColor = .white
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc private func changeAction() {
        if #available(iOS 15.0, *) {
            if let sheet = navigationController?.sheetPresentationController {
                sheet.animateChanges {
                    sheet.selectedDetentIdentifier = .large
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    class Cell: UITableViewCell {
        
    }
}

private let kMiniSpace: CGFloat = 16
private let kLargeSpace: CGFloat = 40
private let kSignInTitle: String = "登录"
private let kSignUpTitle: String = "注册"

fileprivate class LoginViewController: UIViewController {
    
    deinit {
        print("LoginViewController 已销毁")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segView = UISegmentedControl(items: [kSignInTitle, kSignUpTitle])
        segView.selectedSegmentIndex = 0
        segView.addTarget(self, action: #selector(segAction), for: .valueChanged)
        navigationItem.titleView = segView
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kMiniSpace)
            make.top.equalToSuperview().inset(60)
            make.height.equalTo(44)
        }
        
        view.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.left.right.height.equalTo(emailField)
            make.top.equalTo(emailField.snp.bottom).offset(kMiniSpace)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.left.right.height.equalTo(emailField)
            make.top.equalTo(passwordField.snp.bottom).offset(kLargeSpace)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
    }
    
    @objc private func loginAction() {
        
    }
    
    @objc private func segAction(_ seg: UISegmentedControl) {
        
    }
    
    class InfinityButton: UIButton {
        
        convenience init(_ title: String, backgroundColor: UIColor, target: Any, action: Selector) {
            self.init(type: .system)
            
            self.backgroundColor = backgroundColor
            setTitle(title, for: .normal)
            setTitleColor(.white, for: .normal)
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    private lazy var loginButton: InfinityButton = {
        InfinityButton(kSignInTitle, backgroundColor: .systemBlue, target: self, action: #selector(loginAction))
    }()
    
    private lazy var emailField: UITextField = {
        let v = UITextField()
        v.placeholder = "请输入邮箱"
        v.keyboardType = .emailAddress
        v.borderStyle = .roundedRect
        v.returnKeyType = .next
        v.delegate = self
        v.font = .preferredFont(forTextStyle: .body)
        return v
    }()
    
    private lazy var passwordField: UITextField = {
        let v = UITextField()
        v.placeholder = "请输入密码"
        v.keyboardType = .alphabet
        v.borderStyle = .roundedRect
        v.returnKeyType = .done
        v.isSecureTextEntry = true
        v.delegate = self
        v.font = .preferredFont(forTextStyle: .body)
        return v
    }()
    
    private lazy var passwordAgainField: UITextField = {
        let v = UITextField()
        v.placeholder = "请再次输入密码"
        v.keyboardType = .alphabet
        v.borderStyle = .roundedRect
        v.returnKeyType = .done
        v.isSecureTextEntry = true
        v.delegate = self
        v.font = .preferredFont(forTextStyle: .body)
        return v
    }()
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            if passwordField.isFirstResponder {
                passwordAgainField.becomeFirstResponder()
            } else {
                passwordField.becomeFirstResponder()
            }
        } else {
            if passwordField.isFirstResponder {
                passwordField.resignFirstResponder()
            } else {
                passwordAgainField.resignFirstResponder()
            }
        }
        
        return true
    }
}





/*
 
 import Kingfisher
 
 public class WebImageEngine {
 
 fileprivate static var placeholder: UIImage?
 
 public static func register(placeholder: UIImage? = nil) {
 self.placeholder = placeholder
 }
 
 public static func clearCache(_ callback: (() -> Void)? = nil) {
 KingfisherManager.shared.cache.clearCache(completion: callback)
 }
 }
 
 public extension UIImageView {
 
 func xk_setImage(_ url: String?, placeholder: UIImage? = nil) {
 contentMode = .center
 kf.setImage(with: URL(string: url ?? ""), placeholder: placeholder ?? WebImageEngine.placeholder) {[weak self] res in
 self?.contentMode = .scaleToFill
 }
 }
 }
 
 */
