//
//  FavoriteCollectionViewController.swift
//  Recipiner
//
//  Created by Vanessa on 5/26/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FavoriteCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<Recipe>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        setupFetchedResultsController()
        setUpFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            print("Collection fetched:", fetchedResultsController.fetchedObjects?.count)
        } catch {
            print("The recipe fetch could not be performed: \(error.localizedDescription)")
        }
    }

    func setUpFlowLayout() {
        let width = (view.frame.size.width - 2) / 3
        flowlayout.estimatedItemSize = .zero
        flowlayout.itemSize = CGSize(width: width, height: width)
        flowlayout.sectionInset = UIEdgeInsets.zero
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 1
        flowlayout.minimumInteritemSpacing = 1
    }
}

extension FavoriteCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionCell", for: indexPath) as! RecipeCollectionCell
        if !collectionView.isValid(indexPath: indexPath) { return cell }
        let aRecipe = fetchedResultsController.object(at: indexPath)
        if let img = aRecipe.img {
            cell.thumbnail.image = UIImage(data: img)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Col index:", indexPath.row)
        let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailControllerId") as! DetailViewController
        detailController.recipe = fetchedResultsController.object(at: indexPath)
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
//        if urlArray.count > indexPath.row {
//            urlArray.remove(at: indexPath.row)
//        }
//        let photoToDelete = fetchedResultsController.object(at: indexPath)
//        context.delete(photoToDelete)
//        do {
//            try context.save()
//        } catch {
//            print("The photo deletion could not be performed: \(error.localizedDescription)")
//        }
//    }
}
