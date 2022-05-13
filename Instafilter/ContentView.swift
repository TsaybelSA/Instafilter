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
	@State private var showingImagePicker = false
	@State private var filterIntensity = 0.5
	
	@State private var currentFilter = CIFilter.sepiaTone()
	@State private var context = CIContext()
	
    var body: some View {
		NavigationView {
			VStack {
				ZStack {
					Rectangle()
						.fill(.secondary)
					
					Text("Tap to select picture")
						.foregroundColor(.white)
						.font(.headline)
					
					image?
						.resizable()
						.scaledToFit()
				}
				.onTapGesture {
					showingImagePicker = true
				}
				
				HStack {
					Text("Intensity")
					Slider(value: $filterIntensity)
				}
				.padding(.vertical)
				
				HStack {
					Button("Change filter") {}
					
					Spacer()
					
					Button("Save", action: save)
				}
			}
			.padding([.horizontal, .bottom])
			.navigationTitle("Instafilter")
			.onChange(of: inputImage) { _ in loadImage() }
			.sheet(isPresented: $showingImagePicker) {
				ImagePicker(image: $inputImage)
			}
		}
	}
	
	private func loadImage() {
		guard let inputImage = inputImage else { return }
		
		let beginImage = CIImage(image: inputImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		applyProcessing()
	}
	
	private func save() {
		
	}
	
	private func applyProcessing() {
		currentFilter.intensity = Float(filterIntensity)
		
		guard let outputImage = currentFilter.outputImage else { return }
		
		if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
			let uiImage = UIImage(cgImage: cgImage)
			image = Image(uiImage: uiImage)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
