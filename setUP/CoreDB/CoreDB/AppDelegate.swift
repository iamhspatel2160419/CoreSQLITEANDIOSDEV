//
//  AppDelegate.swift
//  CoreDB
//
//  Created by Apple on 09/12/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func deleteIterm()
    {
        
        /* let storeCoordinator:NSPersistentStoreCoordinator =  self.persistentStoreCoordinator
         // print(storeCoordinator)
         let store:NSPersistentStore = storeCoordinator.persistentStores[0] as NSPersistentStore
         let storeURL:URL = store.url!
         
         do
         {
         try self.persistentStoreCoordinator.remove(store)
         try FileManager.default.removeItem(at: storeURL)
         let url = self.applicationDocumentsDirectory.appendingPathComponent("FSM.sqlite")
         try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
         }
         catch { /*dealing with errors up to the usage*/ }
         */
        let supportDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let dbUrl = supportDirectory.appendingPathComponent("FSM.sqlite")
        print("dbUrl",dbUrl)
        
        // let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask);
        //  var dbUrl = urls[urls.count-1];
        // dbUrl = dbUrl.appendingPathComponent("FSM.sqlite")
        do {
            try self.persistentStoreCoordinator.destroyPersistentStore(at: dbUrl, ofType: NSSQLiteStoreType, options: nil);
        } catch {
            print(error);
        }
        do {
            try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbUrl, options: nil);
        } catch {
            print(error);
        }
        
    }
    
    
    lazy var applicationDocumentsDirectory: URL =
        {
            // The directory the application uses to store the Core Data store file. This code uses a directory named "com.rs..SampleCoreData" in the application's documents Application Support directory.
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "HPDEMO", withExtension: "momd")
        print(modelURL)
        
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HPDEMO")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        //  Converted with Swiftify v1.0.6198 - https://objectivec2swift.com/
        var options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        let supportDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let url = supportDirectory.appendingPathComponent("HPDEMO.sqlite")
        print(url)
        var failureReason = "There was an error creating or loading the application's saved data."
        if !(FileManager.default.fileExists(atPath: supportDirectory.path))
        {
            print("[Debug] Could not find \(supportDirectory). Will create now.")
            do
            {
                try FileManager.default.createDirectory(at: supportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                let nserror = error as NSError
                print("withMessage:Could not create the necessary ApplicationSupport directory for the SQLite database. \(error)")
            }
        }
        do
        {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            
        }
        catch
        {
            // Report any error we got.
            /* var dict = [String: AnyObject]()
             dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
             dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
             dict[NSUnderlyingErrorKey] = error as NSError
             let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
             // Replace this with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
             abort()*/
            
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.HPDEMO.HPDEMO", code: 9999, userInfo: dict)
            print("withMessage: Unresolved persistantStoreCoordinator error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        //        if coordinator
        //        {
        //            print(" Error getting managedObjectContext because persistentStoreCoordinator is nil")
        //            return nil
        //        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        let mergePolicy = NSMergePolicy(merge:NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType )
        managedObjectContext.mergePolicy = mergePolicy
        
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                //abort()
            }
        }
    }

}

