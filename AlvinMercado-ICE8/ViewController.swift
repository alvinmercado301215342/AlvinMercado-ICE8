//
//  ViewController.swift
//  AlvinMercado-ICE8
//
//  Created by Alvin Carl Mercado on 2022-03-26.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    func findResults(request: VNRequest, error: Error?) {
       guard let results = request.results as?
       [VNClassificationObservation] else {
       fatalError("Unable to get results")
       }
       var bestGuess = ""
       var bestConfidence: VNConfidence = 0
       for classification in results {
          if (classification.confidence > bestConfidence) {
             bestConfidence = classification.confidence
             bestGuess = classification.identifier
          }
       }
       labelDescription.text = "Image is: \(bestGuess) with confidence \(bestConfidence) out of 1"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let imagePath = Bundle.main.path(forResource: "car", ofType: "jpeg")
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        let modelFile: MobileNetV2 = {
                
                do {
                    
                    let config = MLModelConfiguration()
                    return try MobileNetV2(configuration: config)
                    
                } catch {
                    
                    print(error)
                    fatalError("Couldn't create MobileNetV2")
                    
                }
            }()
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
    }
    
}

