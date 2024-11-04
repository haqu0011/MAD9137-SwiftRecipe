
//

import Foundation

class RecipeManager: ObservableObject {
    @Published var recipes: [Recipe] = []

    private let userDefaultsKey = "recipes"

    init() {
        loadRecipes()
    }

    func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let decodedRecipes = try? decoder.decode([Recipe].self, from: data) {
                recipes = decodedRecipes
            }
        } else {
            // Load default recipes if UserDefaults is empty
            recipes = defaultRecipes()
            saveRecipes() // Save default recipes to UserDefaults
        }
    }

    // Save recipes to UserDefaults
    func saveRecipes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recipes) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Add a new recipe
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes()
    }
    
    // Edit a recipe
    func updateRecipe(_ updatedRecipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            recipes[index] = updatedRecipe
            saveRecipes()
        }
    }
    
    // Delete a recipe
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        saveRecipes()
    }

    private func defaultRecipes() -> [Recipe] {
        return [
            Recipe(description: "A classic Italian pizza with fresh ingredients and vibrant flavors.",
                   title: "Classic Margherita Pizza", headline: "Lunch",
                   ingredients: ["Pizza dough", "Tomatoes", "Fresh mozzarella", "Basil", "Olive oil"],
                   instructions: [
                       "Preheat your oven to its highest temperature.",
                       "Roll out the pizza dough into your desired shape.",
                       "Spread a thin layer of crushed tomatoes over the dough, leaving a border around the edges.",
                       "Tear the fresh mozzarella into small pieces and distribute them evenly over the tomatoes.",
                       "Sprinkle fresh basil leaves on top.",
                       "Drizzle a bit of olive oil over the pizza.",
                       "Bake the pizza on a preheated pizza stone or baking sheet until the crust is golden and the cheese is bubbly, about 10-12 minutes.",
                       "Remove from the oven, let it cool slightly, and enjoy your homemade Margherita pizza."
                   ],
                   imageName: "pizza"),
            
            Recipe(description: "A refreshing and nutritious salad with grilled chicken and mixed greens.",
                   title: "Grilled Chicken Salad", headline: "Lunch",
                   ingredients: ["Chicken breasts", "Mixed greens", "Cherry tomatoes", "Cucumbers", "Balsamic vinaigrette"],
                   instructions: [
                       "Grill the chicken breasts until they are cooked through and have nice grill marks.",
                       "While the chicken is cooking, prepare the salad by washing and drying the mixed greens, slicing the cherry tomatoes, and chopping the cucumbers.",
                       "Once the chicken is done, let it rest for a few minutes before slicing it.",
                       "In a large bowl, toss the greens, tomatoes, and cucumbers together.",
                       "Place the sliced grilled chicken on top.",
                       "Drizzle the balsamic vinaigrette over the salad and toss everything together gently to combine.",
                       "Enjoy your delicious and healthy grilled chicken salad!"
                   ],
                   imageName: "chicken"),
            
            Recipe(description: "A colorful and tasty stir-fry loaded with fresh vegetables and tofu.",
                   title: "Vegetable Stir-Fry", headline: "Dinner",
                   ingredients: ["Assorted vegetables", "Tofu", "Soy sauce", "Ginger", "Garlic", "Sesame oil"],
                   instructions: [
                       "Prepare the vegetables by washing and chopping them into bite-sized pieces.",
                       "Press the tofu to remove excess moisture and cut it into cubes.",
                       "In a wok or large skillet, heat some sesame oil over medium-high heat.",
                       "Add ginger and garlic, sautéing until fragrant.",
                       "Add the tofu and stir-fry until it's golden and slightly crispy.",
                       "Add the chopped vegetables and continue to stir-fry until they're tender yet still slightly crisp.",
                       "Pour in some soy sauce for flavor and toss everything together.",
                       "Serve your colorful vegetable stir-fry over steamed rice or noodles."
                   ],
                   imageName: "stir_fry"),
          
            
            Recipe(description: "A hearty and comforting beef stew perfect for cold days.",
                   title: "Homestyle Beef Stew", headline: "Dinner",
                   ingredients: ["Beef stew meat", "Potatoes", "Carrots", "Onions", "Beef broth", "Thyme"],
                   instructions: [
                       "Cut the beef stew meat into bite-sized pieces and season with salt and pepper.",
                       "Heat oil in a large pot over medium-high heat and brown the beef pieces on all sides.",
                       "Remove the beef from the pot and add chopped onions, sautéing until translucent.",
                       "Add diced carrots and potatoes and stir for a few minutes.",
                       "Return the browned beef to the pot and pour in enough beef broth to cover the ingredients.",
                       "Add thyme and let the stew simmer on low heat for 1.5 to 2 hours until tender.",
                       "Serve your hearty homestyle beef stew with crusty bread."
                   ],
                   imageName: "beef"),
            
            Recipe(description: "A light and fresh Caprese salad with tomatoes, mozzarella, and basil.",
                   title: "Caprese Salad", headline: "Lunch",
                   ingredients: ["Tomatoes", "Fresh mozzarella", "Basil", "Balsamic glaze", "Olive oil"],
                   instructions: [
                       "Slice the tomatoes and fresh mozzarella into rounds of similar thickness.",
                       "Arrange the tomato and mozzarella slices on a plate, alternating and overlapping them.",
                       "Tuck fresh basil leaves between the tomato and mozzarella slices.",
                       "Drizzle balsamic glaze and olive oil over the salad.",
                       "Season with salt and freshly ground black pepper.",
                       "Enjoy this classic Italian-inspired salad as an appetizer or light lunch."
                   ],
                   imageName: "salad"),
        ]

    }
}
