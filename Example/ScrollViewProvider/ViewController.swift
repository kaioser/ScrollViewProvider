//
//  ViewController.swift
//  ScrollViewProvider
//
//  Created by yxkkk on 05/18/2023.
//  Copyright (c) 2023 yxkkk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
