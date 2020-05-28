//
//  FavoriteTableViewController.swift
//  Recipiner
//
//  Created by Vanessa on 5/26/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<Recipe>!
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        tableView.reloadData()
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
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.recipe = fetchedResultsController.object(at: indexPath)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension FavoriteTableViewController  {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aRecipe = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableCell.defaultReuseIdentifier, for: indexPath) as! RecipeTableCell

        cell.title.text = aRecipe.title
        if let img = aRecipe.img {
            cell.thumbnail.image = UIImage(data: img)
        } else {
            cell.thumbnail.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailControllerId") as! DetailViewController
        detailController.recipe = fetchedResultsController.object(at: indexPath)
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension FavoriteTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
                break
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                break
            default:
                break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
            case .insert:
                tableView.insertSections(indexSet, with: .fade)
                break
            case .delete:
                tableView.deleteSections(indexSet, with: .fade)
                break
            default:
                break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
