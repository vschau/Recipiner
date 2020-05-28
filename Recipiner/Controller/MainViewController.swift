//
//  MainViewController.swift
//  Recipiner
//
//  Created by Vanessa on 5/26/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import UIKit
import CoreData

// todo: use child object
// todo: fix scroll layout
class MainViewController: UIViewController {
    @IBOutlet weak var addFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeInstructions: UITextView!
    @IBOutlet weak var navigation: UINavigationItem!
    
    var id: String!
    var name: String!
    var img: Data!
    var ingredients: String!
    var instructions: String!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: -
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
        recipeIngredients.text = "Ingredients"
        recipeInstructions.text = "Instruction"
        //loadRandomRecipe()
    }
    
    func loadRandomRecipe() {
        RecipeClient.getRandomRecipe(completion: handleGetRandomRecipe(recipeDic:error:))
    }

    // id, img, ingredients, instructions    title
    func handleGetRandomRecipe(recipeDic: RecipeDic, error: Error?) {
        assignRecipeProps(recipeDic: recipeDic)
        
        navigation.title = name
        recipeIngredients.text = ingredients
        recipeInstructions.text = instructions
        
        let url = recipeDic["strMealThumb"] ?? nil
        if let url = url {
            RecipeClient.downloadImage(url: url) { (data, error) in
                guard let data = data else {
                    return
                }
                self.img = data
                self.recipeImage.image = UIImage(data: data)
            }
        }
    }
    
    func assignRecipeProps(recipeDic: RecipeDic) {
        id = getDicValue(dict: recipeDic, key: "idMeal")
        name = getDicValue(dict: recipeDic, key: "strMeal")
        instructions = getDicValue(dict: recipeDic, key: "strInstructions")
        
        // Build ingredients string
        // Todo: use an array to store ingredients instead
        var str = ""
        for i in 4...20 {
            let ingKey = "strIngredient" + String(i)
            let anIngredient = getDicValue(dict: recipeDic, key: ingKey)
            let mesKey = "strMeasure" + String(i)
            let meassure = getDicValue(dict: recipeDic, key: mesKey)
            // key exists in dic
            if let anIngredient = anIngredient, !anIngredient.isEmpty {
                if let ms = meassure, !ms.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    str.append("\(anIngredient): \(ms)\n")
                } else {
                    str.append(anIngredient + "\n")
                }
            }
        }
        ingredients = String(str.dropLast(2))
//        print(id)
//        print(name)
//        print(ingredients)
    }
  
    func getDicValue(dict: [String: String?], key: String) -> String? {
        if let val = dict[key] {
            return val
        }
        return nil
    }
    
//    func getDicValue(dict: [String: String?], key: String) -> String {
//        if let val = dict[key] {
//            if let val = val {
//                return val
//            } else {
//                ///println("value is nil")
//            }
//        } else {
//            ///println("key is not present in dict")
//        }
//        return ""
//    }

    @IBAction func markFavorite(_ sender: UIBarButtonItem) {
        let recipe = Recipe(context: context)
        recipe.id = id
        recipe.title = name
        recipe.img = img
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        do {
            try context.save()
            let isSaved = !recipe.objectID.isTemporaryID
            print(recipe.title!, " is saved?", isSaved)
        } catch {
            print(error.localizedDescription)
        }
        
        // Test 1 fetch
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
            fetchRequest.fetchLimit = 1
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            var objects: [Recipe]
            try objects = context.fetch(fetchRequest) as! [Recipe]
            print("First persistent object:", objects[0].title!)
        } catch {}
    }

    @IBAction func refreshRecipe(_ sender: UIBarButtonItem) {
        loadRandomRecipe()
    }
}
