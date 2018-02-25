//
//  Scene.swift
//  arkit-testing-2
//
//  Created by Jordan Osterberg on 7/14/17.
//  Copyright © 2017 Shadow Technical Systems, LLC. All rights reserved.
//

import SpriteKit
import ARKit
import Vision

class Scene: SKScene {
    let inceptionv3model = Inceptionv3()
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            DispatchQueue.global(qos: .background).async {
                do {
                    let model = try VNCoreMLModel(for: Inceptionv3().model)
                    let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                        // Jump onto the main thread
                        DispatchQueue.main.async {
                            // Access the first result in the array after casting the array as a VNClassificationObservation array
                            guard let results = request.results as? [VNClassificationObservation], let result = results.first else {
                                print ("No results?")
                                return
                            }
                            
                            // Create a transform with a translation of 0.2 meters in front of the camera
                            var translation = matrix_identity_float4x4
                            translation.columns.1.z = -0.4
                            let transform = simd_mul(currentFrame.camera.transform, translation)
                            
                            print(result.identifier)
                            debugPrint("I am here!")
//                            // Add a new anchor to the session
                            let anchor = ARAnchor(transform: transform)
//
//                            let uri = "https://api.microsofttranslator.com/V2/Http.svc/Translate"
//                            var params:[String : String]=["text":result.identifier, "from": "en", "to":"es","Ocp-Apim-Subscription-Key":"9c84d7c5826b4bb5aa10157fc3e658a7"]
//                            let translated = self.sendRequest(url: uri, parameters: params, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
                           /*
                            //Implementing URLSession
                            let uri = "https://api.microsofttranslator.com/V2/Http.svc/Translate"
                            let request = NSMutableURLRequest(url: NSURL(string: uri)! as URL)
                            
                            request.httpMethod = "GET"
                            request.setValue("9c84d7c5826b4bb5aa10157fc3e658a7", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
                            
                            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                                
                                if let nsError = error {
                                    completion(result: .Failure(Error.UnexpectedError(nsError: nsError)))
                                }
                                else {
                                    do {
                                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                                        completion(result: .Success(json))
                                    }
                                    catch {
                                        completion(result: .Failure(Error.JSonSerializationError))
                                    }
                                }
                            }
                            task.resume()
                            */
                           
                            /*
                            guard let url = URL(string: uri) else { return }
                            
                            URLSession.shared.dataTask(with: url) { (data, response, error) in
                                if error != nil {
                                    print(error!.localizedDescription)
                                }
                                
                                guard let data = data else { return }
                                
                                }.resume()
                            //End implementing URLSession
                            */
                            
                            
                            
                            
                            
                            // Set the identifier
//                            ARBridge.shared.anchorsToIdentifiers[anchor] = translated
                            //ARBridge.shared.anchorsToIdentifiers[anchor] = result.identifier
                            
                            sceneView.session.add(anchor: anchor)
                        }
                    })
                    
                    let handler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage, options: [:])
                    try handler.perform([request])
                } catch {}
            }
        }
        
        
    }
//
//
//    func sendRequest(url: String, parameters: [String: String], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
//        let parameterString = parameters.stringFromHttpParameters()
//        let requestURL = URL(string: url + "?" + parameterString)!
//
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
//        task.resume()
//
//        return task
//    }
//
    
}

