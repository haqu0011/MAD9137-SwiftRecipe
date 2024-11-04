

import SwiftUI
import PhotosUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeManager: RecipeManager
    var recipe: Recipe

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var headline: String = "Lunch"
    @State private var ingredients: [String] = []
    @State private var instructions: [String] = []
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data?
    @State private var loadedImage: Image? = nil

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Title and Description Section
                    Section(header: Text("Title & Description").font(.headline)) {
                        TextField("Recipe Title", text: $title)
                        TextField("Brief Description", text: $description)
                    }

                    // Meal Type Section
                    Section(header: Text("Meal Type").font(.headline)) {
                        Picker("Select Meal Type", selection: $headline) {
                            Text("Breakfast").tag("Breakfast")
                            Text("Lunch").tag("Lunch")
                            Text("Dinner").tag("Dinner")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    // Ingredients Section
                    Section(header: Text("Ingredients").font(.headline)) {
                        ForEach($ingredients.indices, id: \.self) { index in
                            TextField("Ingredient", text: $ingredients[index])
                        }
                        .onDelete(perform: deleteIngredient)
                        
                        Button(action: addIngredient) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Ingredient")
                            }
                        }
                    }

                    // Instructions Section
                    Section(header: Text("Instructions").font(.headline)) {
                        ForEach($instructions.indices, id: \.self) { index in
                            HStack(alignment: .top) {
                                Text("\(index + 1).")
                                TextField("Step \(index + 1)", text: $instructions[index])
                            }
                        }
                        .onDelete(perform: deleteInstruction)
                        
                        Button(action: addInstruction) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Step")
                            }
                        }
                    }

                    // Recipe Image Section
                    Section(header: Text("Recipe Image")) {
                        if let loadedImage = loadedImage {
                            loadedImage
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        }

                        PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                            HStack {
                                Image(systemName: "photo")
                                Spacer()
                                Text("Select from Photo Library")
                            }
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                        }
                        // Load the selected image data
                        .onChange(of: selectedImage) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                    if let uiImage = UIImage(data: data) {
                                        loadedImage = Image(uiImage: uiImage)
                                    }
                                }
                            }
                        }
                    }

                }

                Spacer()

                // Save Button
                Button(action: saveRecipe) {
                    Text("Save Recipe")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(title.isEmpty || instructions.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(title.isEmpty || instructions.isEmpty)
            }
            .navigationTitle("Edit Recipe")
            .toolbar {
                // Close button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white)
                    }
                }
            }
            .onAppear {
                // Load the recipe data when the view appears
                loadRecipeData()
            }
        }
    }
    
    // MARK: - loadRecipeData Method
    private func loadRecipeData() {
        title = recipe.title
        description = recipe.description
        headline = recipe.headline
        ingredients = recipe.ingredients
        instructions = recipe.instructions
        if let image = Utils.shared.loadImage(named: recipe.imageName) {
               loadedImage = image
        }
    }
    
    // MARK: - saveRecipe
    private func saveRecipe() {
        guard !title.isEmpty, !instructions.isEmpty else { return }

        var imageName: String? = recipe.imageName
        if let imageData = selectedImageData {
            imageName = Utils.shared.saveImageToDocuments(imageData: imageData)
        }

        var updatedRecipe = recipe
        updatedRecipe.title = title
        updatedRecipe.description = description
        updatedRecipe.headline = headline
        updatedRecipe.ingredients = ingredients.filter { !$0.isEmpty }
        updatedRecipe.instructions = instructions.filter { !$0.isEmpty }
        updatedRecipe.imageName = imageName ?? recipe.imageName

        recipeManager.updateRecipe(updatedRecipe)
        dismiss()
    }


    private func addIngredient() {
        ingredients.append("")
    }

    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }

    private func addInstruction() {
        instructions.append("")
    }

    private func deleteInstruction(at offsets: IndexSet) {
        instructions.remove(atOffsets: offsets)
    }
}
