//
//  DataManager.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import Foundation
import CoreData

enum DataManagerKey {
    static let newsArticlesEntity = "NewsArticlesEntity"
}

protocol DataManaging {
    var newsArticles: [Article]? { get set }
}

class DataManager: DataManaging {
    
    let container: NSPersistentContainer
    static let shared = DataManager()
    
    private init() {
        container = NSPersistentContainer(name: "NewsAppDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
    }
    
    var newsArticles: [Article]? {
        get {
            decodableData(entityName: DataManagerKey.newsArticlesEntity, type: [Article].self)
        }
        set {
            setData(data: newValue, entityName: DataManagerKey.newsArticlesEntity)
        }
    }
}

//MARK: - Shared Functions
extension DataManager {
    private func decodableData<T: Decodable>(entityName: String, type: T.Type) -> T? {
        guard let jsonData = getData(entityName: entityName) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            print(error)
        }
        
        do {
            let value = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            if let string = value as? T {
                return string
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func setData<T: Encodable>(data: T?, entityName: String) {
        guard let data else {
            deleteData(entityName: entityName)
            return
        }
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            saveData(entityName: entityName, data: encodedData)
            return
        } catch {
            print(error)
        }
    }
    
    private func saveData(entityName: String, data: Data) {
        deleteData(entityName: entityName)
        let managedContext = container.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) {
            let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
            do {
                managedObject.setValue(data, forKey: "jsonData")
                try managedContext.save()
            } catch {}
        }
    }
    
    private func getData(entityName: String) -> Data? {
        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        guard let result = (try? managedContext.fetch(fetchRequest)) as? [NSManagedObject] else {
            return nil
        }
        return result.first?.value(forKey: "jsonData") as? Data
    }
    
    private func deleteData(entityName: String) {
        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            results.forEach{ managedContext.delete($0 as! NSManagedObject)}
            try managedContext.save()
        } catch {}
    }
}

final class MockDataManager: DataManaging {
    var newsArticles: [Article]?
    
    init(newsArticles: [Article]? = nil) {
        self.newsArticles = newsArticles
    }
}
