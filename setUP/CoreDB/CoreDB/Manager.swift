import UIKit
import CoreData

open class DbManager
{
    static let sharedDbManager = DbManager()
    let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
    
    init()
    {
    }
    
    
//    InsertSchemeDetail.setValue(InsertDetail.object(forKey: "Id") , forKey: "OrderId")
//
//    var InsertSchemeDetail = NSMutableDictionary()
//    InsertSchemeDetail.setValue(InsertDetail.object(forKey: "Id") , forKey: "OrderId")
//    DbManager.sharedDbManager.insertIntoTable(tableName.orderscheme, dictInsertData:
//
//
    
    var previousTableName:String = ""
    var dictAttributes : NSDictionary!
    func insertIntoTable(_ tblName:String,dictInsertData:NSDictionary,isSync:Bool = false)
    {
        
        /*if previousTableName.isEmpty
         {
         previousTableName = tblName
         let managedObject  = NSEntityDescription.insertNewObject(forEntityName: tblName, into: appDelegate.managedObjectContext)
         let entity = managedObject.entity
         dictAttributes = entity.attributesByName as NSDictionary
         }
         if previousTableName != tblName
         {*/
        let managedObject  = NSEntityDescription.insertNewObject(forEntityName: tblName, into: appDelegate.managedObjectContext)
        let entity = managedObject.entity
        dictAttributes = entity.attributesByName as NSDictionary
        
        // }
        
        
        for (key, _) in dictAttributes
        {
            var entityValue : AnyObject
            let tempKey = (key as!String).firstCharacterUpperCase()
            
            if tempKey == "startDate"  || tempKey == "endDate"{
                print(tempKey)
                
            }
            if let val = dictInsertData.object(forKey: key)
            {
                //   //print("key found \(key)")
                entityValue = val as AnyObject
                if entityValue is NSNull
                {
                    
                }
                else
                {
                    managedObject.setValue(entityValue, forKey: key  as! String)
                }
                
            }
            else if ((dictInsertData[tempKey]) != nil )
            {
                
                
                //print("tempKey  found \(tempKey)")
                entityValue = dictInsertData.object(forKey: tempKey)! as AnyObject
                //     //print("entityValue  found \(entityValue)")
                
                if entityValue is NSNull
                {
                    
                }
                else
                {
                    managedObject.setValue(entityValue, forKey: key  as! String)
                }
            }
            else
            {
                if(key as! String == "isSync")
                {
                    managedObject.setValue(isSync, forKey: key  as! String)
                    
                }
            }
        }
        do
        {
            let appdel = UIApplication.shared.delegate as! AppDelegate
            try appdel.managedObjectContext.save()
            //    print("Could  save")
            //5
        } catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
            // return false
        }
        
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ClassNAme> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Retailer> = Retailer.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    
    
    
    func fetchDataFromTable(_ tbleName:String,strPredicate:String,
                            isFetchOffsetSet:Bool=false,
                            isAscending:Bool = false,
                            sortingKey:String = "",
                            iscaseInsensitiveCompareRequire:Bool = false,
                            completion: (_ result: NSArray)->())  {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tbleName)
        
        //let fetchRequest = NSFetchRequest(entityName: tbleName)
        if !strPredicate.isEmpty {
            fetchRequest.predicate = NSPredicate(format: strPredicate)
        }
        if Helper.sharedHelper.batchSize>0
        {
            fetchRequest.fetchBatchSize = 100
            fetchRequest.fetchLimit = 100
        }
        if iscaseInsensitiveCompareRequire == true
        {
            let sortDescriptor = NSSortDescriptor(key: sortingKey, ascending: isAscending, selector: #selector(NSString.caseInsensitiveCompare))
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }
        fetchRequest.returnsObjectsAsFaults = false
        if isFetchOffsetSet
        {
            fetchRequest.fetchOffset = Helper.sharedHelper.routesOffset
        }
        else
        {
            fetchRequest.fetchOffset = 0
        }
        
    
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            completion(results as NSArray)
            //print(results)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    
//    let dictCategoryDetail : NSMutableDictionary = [:]
//
//            let discountPredicate = NSPredicate(format: "productId=\(productId)")
//            DbManager.sharedDbManager.fetchPredicateDataFromTable(tableNam,strPredicate:discountPredicate)
//            {
//                (resultDiscount) in
//                if resultDiscount.count>0
//                {
//                    let objdiscount = resultDiscount[0] as! DiscountDetail
    
    func fetchPredicateDataFromTable(_ tbleName:String,strPredicate:NSPredicate,
                                     isAscending:Bool = false,
                                     sortingKey:String = "",
                                     iscaseInsensitiveCompareRequire:Bool = false,
                                     completion: (_ result: NSArray)->())  {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tbleName)
        fetchRequest.predicate = strPredicate
        
        if iscaseInsensitiveCompareRequire == true
        {
            let sortDescriptor = NSSortDescriptor(key: sortingKey, ascending: isAscending, selector: #selector(NSString.caseInsensitiveCompare))
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        fetchRequest.fetchOffset = Helper.sharedHelper.routesOffset
        
        
        if Helper.sharedHelper.batchSize>0
        {
            fetchRequest.fetchLimit = 100
            fetchRequest.fetchBatchSize = 100
            
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            completion(results as NSArray)
            //print(results)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
        
  
   
    func fetchLastRecord(_ tbleName:String,strPredicate:String="",keyName:String = "",isSortDescriptorsRequire:Bool = false) -> [Any]?
    {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tbleName)
        
        if isSortDescriptorsRequire == true
        {
            let sortDescriptor = NSSortDescriptor(key: keyName, ascending: true)
            let sortDescriptors = [sortDescriptor]
            request.sortDescriptors = sortDescriptors
        }
        if !strPredicate.isEmpty {
            request.predicate = NSPredicate(format: strPredicate)
        }
        do {
            let allElementsCount = try managedContext.count(for: request)
            request.fetchLimit = 1
            if allElementsCount > 0
            {
                request.fetchOffset = allElementsCount - 1
            }
            else
            {
                request.fetchOffset = 0
            }
            request.returnsObjectsAsFaults = false
            let results = try managedContext.fetch(request)
            if results.count > 0
            {
                return results
            }
            else
            {
                return nil
            }
        } catch _ as NSError {
            return nil
        }
    }

 
 
    func fetchCountFor(entityName: String) -> Int {
        
        var count: Int = 0
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.performAndWait {
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            fetchRequest.resultType = NSFetchRequestResultType.countResultType
            
            do {
                count = try managedContext.count(for: fetchRequest)
            } catch {
                //Assert or handle exception gracefully
            }
            
        }
        
        return count
    }
   
    
    func deleteAllData(_ entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            
            for manageObjects in results {
                appDelegate.managedObjectContext.delete(manageObjects as! NSManagedObject)
                try appDelegate.managedObjectContext.save()
                //print(manageObjects)
            }
            
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func deleteSelectedId(_ entity: String,strPredicate:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // let fetchRequest = NSFetchRequest(entityName: entity)
        if !strPredicate.isEmpty
        {
            fetchRequest.predicate = NSPredicate(format: strPredicate)
            
        }
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            fetchRequest.returnsObjectsAsFaults = false
            
            for manageObjects in results {
                appDelegate.managedObjectContext.delete(manageObjects as! NSManagedObject)
                try appDelegate.managedObjectContext.save()
                //print(manageObjects)
            }
            
        } catch let error as NSError
        {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
   
    
    
}
