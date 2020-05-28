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
    
    // MARK: - Life cycles
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
    
    // MARK: - Set up
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
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

// MARK: - UICollectionViewDelegate
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
        } else {
            cell.thumbnail.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailControllerId") as! DetailViewController
        detailController.recipe = fetchedResultsController.object(at: indexPath)
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
