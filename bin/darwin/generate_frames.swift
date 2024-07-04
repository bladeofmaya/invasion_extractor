import AVFoundation
import CoreGraphics
import ImageIO

let args = CommandLine.arguments
let videoPath = args[1]
let outputDir = args[2]
let fps = 2.0

let asset = AVAsset(url: URL(fileURLWithPath: videoPath))
let duration = CMTimeGetSeconds(asset.duration)
let generator = AVAssetImageGenerator(asset: asset)
generator.appliesPreferredTrackTransform = true

for i in stride(from: 0, to: duration, by: 1.0/fps) {
    let time = CMTimeMakeWithSeconds(i, preferredTimescale: 600)
    do {
        let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
        
        // Apply contrast and brightness adjustments
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(1.5, forKey: kCIInputContrastKey) // Adjust contrast
        filter.setValue(0.1, forKey: kCIInputBrightnessKey) // Adjust brightness
        
        if let outputImage = filter.outputImage,
           let context = CIContext(options: nil),
           let adjustedCGImage = context.createCGImage(outputImage, from: outputImage.extent) {
            
            let outputPath = "\(outputDir)/frame_\(String(format: "%04d", Int(i*fps))).jpg"
            let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: outputPath) as CFURL, kUTTypeJPEG, 1, nil)!
            CGImageDestinationAddImage(destination, adjustedCGImage, nil)
            CGImageDestinationFinalize(destination)
        }
    } catch {
        print("Error generating frame at time \(i): \(error)")
    }
}
