
//  Created by Arif Haque


import Foundation

import SwiftUI

class Utils {
    static let shared = Utils() // Singleton instance

    private init() {} // Private initializer to prevent instantiation

    func loadImage(named imageName: String) -> Image? {
        // Check if the image exists in the app bundle
        if let _ = UIImage(named: imageName) {
            return Image(imageName) // Load from bundle if it exists
        }

        // Construct the file path for the image in the documents directory
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)

        // Check if the file exists at that path
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // Load the image data
            if let imageData = try? Data(contentsOf: fileURL), let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        }

        return nil // Return nil if the image doesn't exist
    }
    
    // MARK: - Save the image to the file system and return the filename
     func saveImageToDocuments(imageData: Data) -> String? {
        let filename = UUID().uuidString + ".png"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        
        // Convert the image data to a UIImage, regardless of its original format (e.g., .jpg)
        if let image = UIImage(data: imageData), let pngData = image.pngData() {
            do {
                try pngData.write(to: fileURL)
                return filename
            } catch {
                print("Error saving image to file system: \(error)")
                return nil
            }
        }
        return nil
    }
}
