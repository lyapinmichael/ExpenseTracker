//
//  Coordinator.swift
//  ExpenseTracker
//
//  Created by Ляпин Михаил on 30.06.2023.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    
    func start()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {}
    func removeChildCoordinator(_ coordinator: Coordinator) {}
}

protocol ModuleCoordinator: Coordinator {
    var module: Module { get }
    var moduleType: Module.ModuleType { get }
}
