//
//  MainViewController.swift
//  Recipiner
//
//  Created by Vanessa on 5/26/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import UIKit
import CoreData
import CoreGraphics

class MainViewController: UIViewController {
    @IBOutlet weak var addFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeInstructions: UITextView!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var id: String!
    var name: String!
    var img: Data!
    var ingredients: String!
    var instructions: String!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - managed child object
//    var managedObjectContext: NSManagedObjectContext!
//    private lazy var childManagedObjectContext: NSManagedObjectContext = {
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managedObjectContext.parent = context
//        return managedObjectContext
//    }()

//    private lazy var recipe: Recipe = {
//        return Recipe(context: self.childManagedObjectContext)
//    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        recipeIngredients.text = "Ingredients"
//        recipeInstructions.text = "Instruction"
        /// disable fav btn until finish loading recipe
        addFavoriteButton.isEnabled = false
        //loadRandomRecipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if id != nil, recipeExistsInCoreData(id: id) {
            addFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            addFavoriteButton.image = UIImage(systemName: "heart")
        }
    }

    // MARK: - IBAction
    @IBAction func markFavorite(_ sender: UIBarButtonItem) {
        if recipeExistsInCoreData(id: id) { return }
        let recipe = Recipe(context: context)
        recipe.id = id
        recipe.title = name
        if let img = img {
            let scaledImg = UIImage(data: img)?.scaledDown(into: CGSize(width: 300, height: 300))
            recipe.img = scaledImg?.pngData()
        }
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        do {
            try context.save()
            //let isSaved = !recipe.objectID.isTemporaryID
            addFavoriteButton.image = UIImage(systemName: "heart.fill")
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func refreshRecipe(_ sender: UIBarButtonItem) {
        addFavoriteButton.image = UIImage(systemName: "heart")
        recipeImage.image = UIImage(named: "placeholder")
        loadRandomRecipe()
    }

    // MARK: - Core Data methods
    func loadRandomRecipe() {
        activityIndicator.startAnimating()
        RecipeClient.getRandomRecipe(completion: handleGetRandomRecipe(recipeDic:error:))
    }

    func recipeExistsInCoreData(id: String) -> Bool {
        var results: [Recipe] = []
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            results = try context.fetch(fetchRequest) as! [Recipe]
        } catch {
            print(error.localizedDescription)
        }
        return results.count > 0
    }

    // MARK: - Completion Handler
    func handleGetRandomRecipe(recipeDic: RecipeDic, error: Error?) {
        assignRecipeProps(recipeDic: recipeDic)

        navigation.title = name
        recipeIngredients.text = ingredients
        recipeInstructions.text = instructions

        let url = recipeDic["strMealThumb"] ?? nil
        if let url = url {
            RecipeClient.downloadImage(url: url) { (data, error) in
                guard let data = data else { return }
                self.img = data
                self.recipeImage.image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.addFavoriteButton.isEnabled = true
                }
            }
        }
    }

    // MARK: - Helpers
    func assignRecipeProps(recipeDic: RecipeDic) {
        id = getDicValue(dict: recipeDic, key: "idMeal")
        name = getDicValue(dict: recipeDic, key: "strMeal")
        instructions = getDicValue(dict: recipeDic, key: "strInstructions")

        // Build ingredients string
        var str = ""
        for i in 4...20 {
            let ingKey = "strIngredient" + String(i)
            let anIngredient = getDicValue(dict: recipeDic, key: ingKey)
            let mesKey = "strMeasure" + String(i)
            let meassure = getDicValue(dict: recipeDic, key: mesKey)
            // check if key exists in dic and isn't an empty string
            if let anIngredient = anIngredient, !anIngredient.isEmpty {
                if let ms = meassure, !ms.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    str.append("\(anIngredient): \(ms)\n")
                } else {
                    str.append(anIngredient + "\n")
                }
            }
        }
        ingredients = String(str.dropLast(2))
        print(str)
        print(instructions)
    }

    func getDicValue(dict: [String: String?], key: String) -> String? {
        if let val = dict[key] {
            return val
        }
        return nil
    }
}
