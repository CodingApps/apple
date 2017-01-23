//
//  LibraryBooksController.swift
//  Kiwix
//
//  Created by Chris Li on 1/23/17.
//  Copyright © 2017 Chris Li. All rights reserved.
//

import UIKit
import CoreData

class LibraryBooksController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
