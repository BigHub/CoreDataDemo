//
//  ViewController.swift
//  CoreData
//
//  Created by jianwei on 15/7/21.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    lazy var appdelegate = {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }()
    
    @IBOutlet weak var booktext: UITextField!
    
    @IBOutlet weak var authortext: UITextField!

    
    @IBAction func insert(sender: AnyObject){
        
        //为实体增加新的托管对象
        var object:Book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext:appdelegate.managedObjectContext! ) as! Book
        
        //给托管对象属性赋值
        object.name = booktext.text
        object.author = authortext.text
        
        //将插入的托管对象保存到数据库
        appdelegate.saveContext()
        
        
    }
    
    @IBAction func deleteitem(sender: AnyObject) {
        
        var request = NSFetchRequest(entityName: "Book")
        var predicate = NSPredicate(format: "%K == %@", "name", booktext.text)
        
        request.predicate = predicate
        
        var error: NSError?
        var result = appdelegate.managedObjectContext!.executeFetchRequest(request, error: &error) as![NSManagedObject]
        
        for obj: NSManagedObject in result{
            //删除查找到的书籍
            appdelegate.managedObjectContext!.deleteObject(obj)
        }
        
        appdelegate.saveContext()
        
    }
    
    @IBAction func update(sender: AnyObject) {
        var request = NSFetchRequest(entityName: "Book")
        var predicate = NSPredicate(format: "%K == %@", "name", booktext.text)
        request.predicate = predicate
        
        var error:NSError?
        
        //按书名查找
        var result = appdelegate.managedObjectContext!.executeFetchRequest(request, error: &error) as![NSManagedObject]
        
        for obj:NSManagedObject in result {
            //修改作者名字
            obj.setValue(authortext.text, forKey: "author")
        }
        
        //保存数据更改
        appdelegate.saveContext()
    }

    @IBAction func query(sender: AnyObject) {
        
        var request = NSFetchRequest(entityName: "Book")
        
        //如果书名不为空则按书名作为查询条件查找，否则列出所有对象
        if !booktext.text.isEqual(""){
            var predicate = NSPredicate(format: "%K == %@", "name", booktext.text)
            request.predicate = predicate
        }
        
        var error: NSError?
        
        var result = appdelegate.managedObjectContext?.executeFetchRequest(request, error: &error) as? [Book]
        
        if let r = result{
            for book in r{
                NSLog("---- query result --> name:%@  author:%@",book.name, book.author)
            }
           
        }
    }
}

