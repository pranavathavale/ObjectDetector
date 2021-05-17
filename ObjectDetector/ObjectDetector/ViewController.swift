//
//  ViewController.swift
//  ObjectDetector
//
//  Created by Pranav Athavale on 17/05/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Failed to convert the image")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: YOLOv3().model) else {
             fatalError("Failed to load model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                fatalError("Model failed to process image")
            }
//            let results = request.results
//            print("your results are \(type(of: results))")
//
//            if let results = request.results as? [VNClassificationObservation] {
//                print("your results are of type VNClassificationObservation")
//            }
//
//            if let results = request.results as? [VNPixelBufferObservation] {
//                print("your results are of type VNPixelBufferObservation")
//            }
//
//            if let results = request.results as? [VNCoreMLFeatureValueObservation] {
//                print("your results are of type VNCoreMLFeatureValueObservation")
//            }
            self.navigationItem.title = results.first?.labels[0].identifier
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
           try handler.perform([request])
        } catch{
            print(error)
        }
        
    }

    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

