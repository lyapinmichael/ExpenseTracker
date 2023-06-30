//
//  AppFactory.swift
//  ExpenseTracker
//
//  Created by Ляпин Михаил on 30.06.2023.
//

import Foundation
import UIKit

final class AppFactory {
    
    static func makeModule(_ type: Module.ModuleType) -> Module {
        switch type {
        case .base:
            let view = UINavigationController(rootViewController: ViewController())
            view.title = "Base Module"
            return Module(module: type, viewModel: nil, view: view)
            
        }
    }
}
