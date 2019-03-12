//
//  ViewController.swift
//  SnapKitHack
//
//  Created by Salman Fakhri on 3/9/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var previewView: UIView = {
        return UIView()
    }()
    
    var captureButton: UIButton = {
        return UIButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        navigationController?.isNavigationBarHidden = true
        setUpPreviewView()
        setUpCaptureButton()
        setUpCamera()
        
    }
    
    func setUpPreviewView() {
        previewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewView)
        previewView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        previewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setUpCaptureButton() {
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        captureButton.backgroundColor = UIColor(white: 1, alpha: 0.5)
        captureButton.layer.cornerRadius = 40
        captureButton.layer.borderWidth = 5
        captureButton.layer.borderColor = UIColor.white.cgColor
        
        
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
    }
    
    @objc func captureImage() {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        print("took photo")
    }
    
    func setUpCamera() {
        let devices = AVCaptureDevice.devices(for: .video)
        var captureDevice: AVCaptureDevice?
        for device in devices {
            if device.position == .front {
                captureDevice = device
            }
        }
        
        do {
            guard let captureDevice = captureDevice else { return }
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            guard let session = captureSession else { return }
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            // Set the output on the capture session
            guard let output = capturePhotoOutput else { return }
            captureSession?.addOutput(output)
            
            captureSession?.startRunning()
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        
        guard let photoData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage.init(data: photoData) else { return }
        
        //addImageToView(image: image)
        
        let vc = DetailViewController()
        vc.addImageToPreview(image: image)
        navigationController?.pushViewController(vc, animated: false)
//        present(vc, animated: false) {
//            print("presented detail")
//        }
        
        
        print("finished processing photo")
    }
    
}

