

import SwiftUI

struct RecipeImageView: View {
    let imageName: String

    var body: some View {
        if let image = Utils.shared.loadImage(named: imageName) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
        } else if !imageName.isEmpty {
            // Fallback to the bundled image
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
        } else {
            // Placeholder image
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
        }
    }
}


#Preview {
    RecipeImageView(imageName: "chicken")
}
