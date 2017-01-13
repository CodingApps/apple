//
//  Controllers.swift
//  Kiwix
//
//  Created by Chris Li on 11/15/16.
//  Copyright © 2016 Chris Li. All rights reserved.
//

import UIKit

class Controllers {
    
    // MARK: - Main
    
    class var main: MainController {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nav = appDelegate.window?.rootViewController as! UINavigationController
        return nav.topViewController as! MainController
    }

    // MARK: - Bookmark

    private(set) lazy var bookmark = UIStoryboard(name: "Bookmark", bundle: nil).instantiateInitialViewController() as! UINavigationController
    private(set) lazy var bookmarkHUD = UIStoryboard(name: "Bookmark", bundle: nil).instantiateViewController(withIdentifier: "BookmarkHUD") as! BookmarkHUD
    
    // MARK: - Library
    
    private var _library: UIViewController?
    var library: UIViewController {
        let controller = _library ?? UIStoryboard(name: "Library", bundle: nil).instantiateInitialViewController()!
        _library = controller
        return controller
    }
    
    // MARK: -  Search
    
    private var _search: SearchContainer?
    var search: SearchContainer {
        let controller = _search ?? UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController() as! SearchContainer
        _search = controller
        return controller
    }
//    
//    // MARK: - Setting
//    
//    private var setting: UIViewController?
//    
//    class var setting: UIViewController {
//        let controller = Controllers.shared.setting ?? UIStoryboard(name: "Setting", bundle: nil).instantiateInitialViewController()!
//        Controllers.shared.setting = controller
//        return controller
//    }
    
    // MARK: - Welcome
    
    private var _welcome: WelcomeController?
    var welcome: WelcomeController {
        let controller = _welcome ?? UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController() as! WelcomeController
        _welcome = controller
        return controller
    }
    
}
