
//

import SwiftUI

@main
struct RecipeBookUIApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeView(recipeManager: RecipeManager())
        }
    }
}
