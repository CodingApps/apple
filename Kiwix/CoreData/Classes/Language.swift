//
//  Language.swift
//  Kiwix
//
//  Created by Chris on 12/12/15.
//  Copyright © 2015 Chris. All rights reserved.
//

import Foundation
import CoreData


class Language: NSManagedObject {

    class func fetchOrAdd(code: String, context: NSManagedObjectContext) -> Language? {
        let code = NSLocale.canonicalLanguageIdentifierFromString(code)

        if let language = fetch(code, context: context) {
            return language
        }
        
        guard let language = insert(Language.self, context: context) else {return nil}
        language.code = code
        language.name = NSLocale.currentLocale().displayNameForKey(NSLocaleLanguageCode, value: code)
        return language
    }
    
    class func fetch(code: String, context: NSManagedObjectContext) -> Language? {
        let fetchRequest = NSFetchRequest(entityName: "Language")
        fetchRequest.predicate = NSPredicate(format: "code == %@", code)
        return fetch(fetchRequest, type: Language.self, context: context)?.first
    }
    
    class func fetch(displayed displayed: Bool, context: NSManagedObjectContext) -> [Language] {
        let fetchRequest = NSFetchRequest(entityName: "Language")
        fetchRequest.predicate = NSPredicate(format: "isDisplayed == %@ AND name != nil", displayed)
        return fetch(fetchRequest, type: Language.self, context: context) ?? [Language]()
    }
    
    class func fetchAll(context: NSManagedObjectContext) -> [Language] {
        let fetchRequest = NSFetchRequest(entityName: "Language")
        return fetch(fetchRequest, type: Language.self, context: context) ?? [Language]()
    }
    
    // MARK: - Computed Properties
    
    var nameInCurrentLocale: String? {
        guard let code = code else {return nil}
        return NSLocale.currentLocale().displayNameForKey(NSLocaleIdentifier, value: code)
    }
    
    var nameInOriginalLocale: String? {
        guard let code = code else {return nil}
        return NSLocale(localeIdentifier: code).displayNameForKey(NSLocaleIdentifier, value: code)
    }
}
