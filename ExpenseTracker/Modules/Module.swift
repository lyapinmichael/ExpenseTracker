//
//  Module.swift
//  ExpenseTracker
//
//  Created by Ляпин Михаил on 30.06.2023.
//

import Foundation
import UIKit.UIViewController
import UIKit.UITabBarItem

protocol ViewModel: AnyObject {
    
}

struct Module {
    
    enum ModuleType {
        case base
    }
    
    let module: ModuleType
    let viewModel: ViewModel?
    let view: UIViewController
    
}

extension Module.ModuleType {
    
    var tabBarItem: UITabBarItem? {
        switch self {
        case .base:
            return UITabBarItem(title: "Base", image: UIImage(systemName: "house.fill"), tag: 0)
        }
    }
    
}
