

import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeManager: RecipeManager

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var headline: String = "Lunch"
    @State private var ingredients: [String] = []
    @State private var instructions: [String] = []  // Now an array of steps
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Title and Description Section
                    Section(header: Text("Title & Description")
                        .font(.headline)
                        .foregroundColor(.primary)) {
                            TextField("Recipe Title", text: $title)
                                .padding(.vertical, 8)
                            TextField("Brief Description", text: $description)
                                .padding(.vertical, 8)
                        }
                    
                    // Meal Type Section
                    Section(header: Text("Meal Type")
                        .font(.headline)
                        .foregroundColor(.primary)) {
                            Picker("Select Meal Type", selection: $headline) {
                                Text("Breakfast").tag("Breakfast")
                                Text("Lunch").tag("Lunch")
                                Text("Dinner").tag("Dinner")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.vertical, 8)
                        }
                    
                    // Ingredients Section
                    Section(header: Text("Ingredients")
                        .font(.headline)
                        .foregroundColor(.primary)) {
                            ForEach($ingredients.indices, id: \.self) { index in
                                TextField("Ingredient", text: $ingredients[index])
                                    .padding(.vertical, 6)
                            }
                            .onDelete(perform: deleteIngredient)
                            
                            Button(action: addIngredient) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                    Text("Add Ingredient")
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    
                    // Instructions (Steps) Section
                    Section(header: Text("Instructions")
                        .font(.headline)
                        .foregroundColor(.primary)) {
                            ForEach(instructions.indices, id: \.self) { index in
                                HStack(alignment: .top) {
                                    Text("Step \(index + 1):")
                                        .bold()
                                    
                                    TextField("Enter step description", text: Binding(
                                        get: { instructions[index] },
                                        set: { instructions[index] = $0 }
                                    ))
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteStep)
                            
                            Button(action: addStep) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                    Text("Add Step")
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    
                    // Recipe Image Section
                    Section(header: Text("Recipe Image")) {
                        
                        PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                            if let imageData = selectedImageData, let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                        }
                        .padding(.vertical, 10)
                        .onChange(of: selectedImage) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Save Button
                Button(action: saveRecipe) {
                    Text("Save Recipe")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(title.isEmpty || instructions.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(title.isEmpty || instructions.isEmpty)
            }
            .navigationTitle("Add New Recipe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Methods
    
    private func saveRecipe() {
        guard !title.isEmpty, !instructions.isEmpty else {
            return
        }
        
        var imageName: String? = nil
        
        if let imageData = selectedImageData {
            imageName = Utils.shared.saveImageToDocuments(imageData: imageData)
        }
        
        let newRecipe = Recipe(
            description: description,
            title: title,
            headline: headline,
            ingredients: ingredients.filter { !$0.isEmpty },
            instructions: instructions.filter { !$0.isEmpty }, // Save steps
            imageName: imageName ?? ""
        )
        
        recipeManager.addRecipe(newRecipe)
        dismiss()
    }
    
    private func addIngredient() {
        ingredients.append("")
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    private func addStep() {
        instructions.append("") // Adds an empty step
    }
    
    private func deleteStep(at offsets: IndexSet) {
        instructions.remove(atOffsets: offsets)
    }
}

#Preview {
    AddRecipeView(recipeManager: RecipeManager())
}

