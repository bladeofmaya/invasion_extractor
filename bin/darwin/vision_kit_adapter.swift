#!/usr/bin/env swift
import Vision
import Foundation

func recognizeTextHandler(request: VNRequest, error: Error?) -> [String] {
    guard let observations = request.results as? [VNRecognizedTextObservation] else {
        return []
    }
    return observations.compactMap { observation in
        observation.topCandidates(1).first?.string
    }
}

func getTextInImage(imagePath: String) -> [String] {
    let requestHandler = VNImageRequestHandler(
        url: URL(fileURLWithPath: imagePath),
        options: [:]
    )
    let request = VNRecognizeTextRequest()
    // request.recognitionLevel = .fast
    
    do {
        try requestHandler.perform([request])
        return recognizeTextHandler(request: request, error: nil)
    } catch {
        fputs("Unable to recognise text in \(imagePath): \(error).\n", stderr)
        return []
    }
}

func processImages(imagePaths: [String]) -> [[String: Any]] {
    return imagePaths.map { path in
        ["path": path, "text": getTextInImage(imagePath: path)]
    }
}

let arguments = CommandLine.arguments
if arguments.count < 2 {
    fputs("Usage: \(arguments[0]) IMAGE_PATH [IMAGE_PATH ...]\n", stderr)
    exit(1)
}
let imagePaths = Array(arguments.dropFirst())

let results = processImages(imagePaths: imagePaths)
do {
    let jsonData = try JSONSerialization.data(withJSONObject: results)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }
} catch {
    fputs("Unable to serialize the result as JSON: \(error).\n", stderr)
    exit(1)
}
