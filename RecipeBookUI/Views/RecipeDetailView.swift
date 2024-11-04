

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                RecipeCard(recipe: recipe)
                    .padding()
                
                Text(recipe.headline)
                    .font(.title).bold()
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Instructions:")
                        .font(.title3).bold()
                        .padding([.leading, .top], 20)
                    
                    // Vertical scroll view for instructions with multiline text
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                                Text("\(index + 1). \(instruction)")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 250)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ingredients:")
                            .font(.title3)
                            .bold()
                            .padding(.leading, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    Text(ingredient)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 8)
                                        .foregroundColor(.white.opacity(0.8))
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                }
                            }
                            .padding([.horizontal, .bottom], 20)
                        }
                    }

                }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .background(.ultraThinMaterial)
        .navigationTitle(recipe.title)
        .navigationBarItems(trailing: Image(systemName: "xmark.circle.fill").onTapGesture {
            dismiss()
        })
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(
            description: "",
            title: "Classic Margherita Pizza",
            headline: "Lunch",
            ingredients: ["Pizza dough", "Tomatoes", "Fresh mozzarella", "Basil leaves", "Olive oil"],
            instructions: [
                "Preheat your oven to its highest temperature.",
                "Roll out the pizza dough into your desired shape.",
                "Spread a thin layer of crushed tomatoes over the dough.",
                "Tear the fresh mozzarella into small pieces and spread evenly.",
                "Sprinkle fresh basil leaves on top.",
                "Drizzle a bit of olive oil over the pizza.",
                "Bake the pizza on a preheated pizza stone or baking sheet.",
                "Remove from the oven, let it cool slightly, and serve hot."
            ],
            imageName: "pizza"))
            .preferredColorScheme(.dark)
    }
}
