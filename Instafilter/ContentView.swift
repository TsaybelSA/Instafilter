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
	
	@State private var currentFilter: CIFilter = CIFilter.sepiaTone()
	@State private var context = CIContext()
	
	@State private var showingFilterSheet = false
	
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
						.onChange(of: filterIntensity) { _ in applyProcessing() }
				}
				.padding(.vertical)
				
				HStack {
					Button("Change filter") {
						showingFilterSheet = true
					}
					
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
			.confirmationDialog("Choose", isPresented: $showingFilterSheet) {
				Button("Crystallized") { setFilter(CIFilter.crystallize()) }
				Button("Comic Effect") { setFilter(CIFilter.comicEffect()) }
				Button("Box Blur") { setFilter(CIFilter.boxBlur()) }
				Button("Edges") { setFilter(CIFilter.edges()) }
				Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
				Button("Pixellate") { setFilter(CIFilter.pixellate()) }
				Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
				Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
				Button("Vignette") { setFilter(CIFilter.vignette()) }
				Button("Cancel", role: .cancel) { }
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
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) {
			currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
		}
		if inputKeys.contains(kCIInputRadiusKey) {
			currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
		}
		if inputKeys.contains(kCIInputScaleKey) {
			currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
		}
		
		guard let outputImage = currentFilter.outputImage else { return }
		
		if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
			let uiImage = UIImage(cgImage: cgImage)
			image = Image(uiImage: uiImage)
		}
	}
	
	private func setFilter(_ filter: CIFilter) {
		currentFilter = filter
		loadImage()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
