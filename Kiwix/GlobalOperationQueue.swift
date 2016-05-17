//
//  GlobalOperationQueue.swift
//  Kiwix
//
//  Created by Chris Li on 5/14/16.
//  Copyright © 2016 Chris. All rights reserved.
//

class GlobalOperationQueue: OperationQueue {
    static let sharedInstance = GlobalOperationQueue()
    
    var isRefreshingLibrary: Bool {
        let op = operation(String(RefreshLibraryOperation))
        return op != nil
    }
}
