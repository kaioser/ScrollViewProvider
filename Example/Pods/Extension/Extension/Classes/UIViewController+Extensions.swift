//
//  UIViewController+Extensions.swift
//  XKExtension
//
//  Created by 杨雄凯 on 2023/3/21.
//

public extension UIViewController {
    
    static func current() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return nil }
        guard let window = windowScene.windows.first else { return nil }
        return currentController(window.rootViewController)
    }
}

extension UIViewController {
    
    static private func currentController(_ vc: UIViewController?) -> UIViewController? {
        
        if vc == nil { return nil }
        
        if let presentVC = vc?.presentedViewController {
            return currentController(presentVC)
        }
        
        else if let tabVC = vc as? UITabBarController {
            if let selectVC = tabVC.selectedViewController {
                return currentController(selectVC)
            }
            return nil
        }
        
        else if let nav = vc as? UINavigationController {
            return currentController(nav.visibleViewController)
        }
        
        else {
            return vc
        }
    }
}
