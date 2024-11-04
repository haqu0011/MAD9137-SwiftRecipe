


import SwiftUI

struct RecipeView: View {
    @ObservedObject var recipeManager: RecipeManager
    @State private var selectedRecipe: Recipe? = nil
    @State private var isAddingNewRecipe = false
    @State private var isEditingRecipe = false
    @State private var searchText = ""
    @State private var recipeToDelete: Recipe?
    @State private var showingDeleteConfirmation = false
    
    // Filtered recipes based on search text (title or ingredients)
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            // Show all recipes if search text is empty
            return recipeManager.recipes
        } else {
            // Filter recipes based on title or ingredients
            return recipeManager.recipes.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.joined(separator: ", ").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            // List of recipes with swipe actions
            List {
                ForEach(filteredRecipes) { recipe in
                    // Navigate to the recipe detail view on tap
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        // Display the recipe card
                        RecipeCard(recipe: recipe)
                    }
                    .swipeActions(edge: .trailing) {
                        // Delete button with destructive style
                        Button(role: .destructive) {
                            recipeToDelete = recipe // Set the recipe to delete
                            showingDeleteConfirmation = true // Show the action sheet
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        // Edit button to navigate to the edit view
                        Button {
                            selectedRecipe = recipe  // Set the recipe to edit
                            isEditingRecipe = true // Show edit view
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Recipes")
            .toolbar {
                // Add new recipe button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingNewRecipe = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search Recipes") // Adds the search bar
            .sheet(isPresented: $isAddingNewRecipe) {
                // Present a view to add a new recipe
                AddRecipeView(recipeManager: recipeManager)
            }
            .sheet(isPresented: $isEditingRecipe, onDismiss: {
                // Clear the selected recipe after editing
                selectedRecipe = nil
            }) {
                if let selectedRecipe = selectedRecipe {
                    EditRecipeView(recipeManager: recipeManager, recipe: selectedRecipe)
                }
            }
            // Action sheet to confirm recipe deletion
            .actionSheet(isPresented: $showingDeleteConfirmation) {
                ActionSheet(title: Text("Delete Recipe"), message: Text("Are you sure you want to delete this recipe?"), buttons: [
                    .destructive(Text("Delete")) {
                        if let recipeToDelete = recipeToDelete {
                            recipeManager.deleteRecipe(recipeToDelete)
                        }
                    },
                    .cancel()
                ])
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipeManager: RecipeManager())
            .preferredColorScheme(.dark)
    }
}
