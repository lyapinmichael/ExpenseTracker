//
//  TransactionCDService.swift
//  ExpenseTracker
//
//  Created by Ляпин Михаил on 28.06.2023.
//

///
///  Класс TransactionCDService является основным интерфейсом по работе с CoreData моделью TransactionModel
///

//TODO: реализовать методы

import Foundation
import CoreData

final class TransactionCDService {
    
    enum TransactionServiceError: Error {
        case transactionAlreadySaved
        case categoryAlreadyExists
    }
    
    struct NewTransaction {
      
        let uuid: UUID
        let value: Float
        let isPlanned: Bool
        let date: Date
        let note: String
        let category: TransactionCategory?
    }
    
    struct NewCategory {
        let name: String
        let isExpense: Bool
    }

    // Синглтон-инстанс
    static var shared = TransactionCDService()
    
    
    var transactions: [Transaction] = []
    var categories: [TransactionCategory] = []
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionModel")
        container.loadPersistentStores(completionHandler: {storeDescription, error in
            if let error = error {
                print("Core Data error: " + error.localizedDescription)
            }
        })
        return container
    }()
    
    private lazy var viewContext = persistentContainer.viewContext
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    private init() {
        
    }
    
    func fetchTransactions() {
        let fetchRequest = Transaction.fetchRequest()
        transactions = (try? backgroundContext.fetch(fetchRequest)) ?? []
    }
    
    func fetchCategories() {
        let fetchRequest = TransactionCategory.fetchRequest()
        categories = (try? backgroundContext.fetch(fetchRequest)) ?? []
    }
    
    // Добавление и удаление отдельных транзакций
    
    func addTransaction(_ newTransaction: TransactionCDService.NewTransaction, completion: @escaping (Result<Any, TransactionServiceError>) -> Void ) {
        
        guard !transactions.contains(where: {$0.uuid == newTransaction.uuid}) else {
            completion(.failure(.transactionAlreadySaved))
            return
        }
        
        persistentContainer.performBackgroundTask({ [weak self] backgoundContext in
            guard let self = self else { return }
            
            var transaction = Transaction.init(context: backgoundContext)
            
            transaction.uuid = newTransaction.uuid
            transaction.value = newTransaction.value
            transaction.isPlanned = newTransaction.isPlanned
            transaction.note = newTransaction.note
            transaction.date = newTransaction.date
            transaction.category = newTransaction.category

            
            try? backgoundContext.save()
            
            DispatchQueue.main.async {
                self.fetchTransactions()
                completion(.success(true))
            }
        })
    }
    
    func deleteTransaction(atIndex index: Int) {
        persistentContainer.performBackgroundTask({ [weak self] backgroundContext in
            guard let self = self else { return }
            
            backgroundContext.delete(self.transactions[index])
            try? backgroundContext.save()
            self.fetchTransactions()

        })
    }
    
    // Добавление и удаление категорий
    
    func addCategory(_ newCategory: TransactionCDService.NewCategory, completion: @escaping (Result<Any, TransactionServiceError>) -> Void) {
        
        guard !categories.contains(where: {$0.name == newCategory.name && $0.isExpense == newCategory.isExpense}) else {
            completion(.failure(.categoryAlreadyExists))
            return
        }
        
        let category = TransactionCategory.init(context: backgroundContext)
        
        category.name = newCategory.name
        category.isExpense = newCategory.isExpense
        
        try? backgroundContext.save()
        fetchCategories()
        completion(.success(true))
    }
    
    func deleteCategory(atIndex index: Int) {
        backgroundContext.delete(categories[index])
        try? backgroundContext.save()
        fetchCategories()
    }
}



