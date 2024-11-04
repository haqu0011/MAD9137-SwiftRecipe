

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            RecipeImageView(imageName: recipe.imageName)
                .cornerRadius(15)
            
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.headline)
                    .bold()
                
                Text(recipe.description)
                    .font(.subheadline)
                    .lineLimit(2)
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: Recipe(description: "", title: "Vegetable Stir-Fry", headline: "Dinner",
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
                                  imageName: "stir_fry"))
        .preferredColorScheme(.dark)
    }
}
