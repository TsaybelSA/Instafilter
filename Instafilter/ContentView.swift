//
//  ContentView.swift
//  Instafilter
//
//  Created by Сергей Цайбель on 12.05.2022.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI


struct ContentView: View {
	@State private var image: Image?
	@State private var inputImage: UIImage?
	@State private var showImagePicker = false
	
    var body: some View {
		VStack {
			image?
				.resizable()
				.scaledToFit()
			
			Button("Add image") {
				showImagePicker = true
			}
			
			Button("Save image") {
				guard let inputImage = inputImage else { return }
				let imageSaver = ImageSaver()
				imageSaver.writeToPhotoAlbum(image: inputImage)
			}
		}
		.sheet(isPresented: $showImagePicker) {
			ImagePicker(image: $inputImage)
		}
		.onChange(of: inputImage) { _ in loadImage() }
			
	}
	
	func loadImage() {
		guard let inputImage = inputImage else { return }
		image = Image(uiImage: inputImage)
		
		UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
