//
//  camaraController.swift
//  AV Foundation
//
//  Created by Austin Teshuba on 2018-05-14.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
// This is going to do all of the heavy lifting for a camara class
// inspired by: https://www.appcoda.com/avfoundation-swift-guide/

import Foundation
import AVFoundation
import UIKit

class CameraController: NSObject {
    var captureSession: AVCaptureSession?//this is the session for camera capture
    var frontCam: AVCaptureDevice?//this is the object of the front and back camera controls
    var backCam: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?//this gets if the current camera is facing front or rear
    var frontCameraInput: AVCaptureDeviceInput?//these are the input objects where we can get images from
    var backCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?//this is how we get the photos out of the input
    
    var previewLayer: AVCaptureVideoPreviewLayer?//holds preview layer that will display the feed from the camera
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    func switchCameras() throws {//controls switching cams
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.backCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCam else { throw CameraControllerError.invalidOperation }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
                
            else { throw CameraControllerError.invalidOperation }
            
            
        }
        func switchToRearCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                let backCamera = self.backCam else { throw CameraControllerError.invalidOperation }
            
            self.backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.backCameraInput!) {
                captureSession.addInput(self.backCameraInput!)
                
                self.currentCameraPosition = .back
            }
                
            else { throw CameraControllerError.invalidOperation }
            
            
        }
        
        //7
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .back:
            try switchToFrontCamera()
        }
        
        //8
        captureSession.commitConfiguration()
    }
    
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {//this prepares the camera for use. Decoupled from init.
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        func configCaptureDevices() throws {
            //this gets the camaras from the session
            let session = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
            guard let cameras = (session?.devices.flatMap { $0 }), !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
            
            //2
            for camera in cameras {
                if camera.position == .front {
                    self.frontCam = camera
                }
                
                if camera.position == .back {
                    self.backCam = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
            
        }
        func configDeviceInputs() throws {
            //3
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            //4
            if let rearCamera = self.backCam {
                self.backCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.backCameraInput!) { captureSession.addInput(self.backCameraInput!) }
                
                self.currentCameraPosition = .back
            }
                
            else if let frontCamera = self.frontCam {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.currentCameraPosition = .front
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
            
            
        }
        func configPhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
            
            guard let photoOut = self.photoOutput else {
                throw CameraControllerError.noCamerasAvailable
            }
            if captureSession.canAddOutput(photoOut) {
                captureSession.addOutput(photoOut)
            }
            
            captureSession.startRunning()
            
        }
        
        DispatchQueue(label: "prepare").async {//this is an asynchronous thread to prepare the camera.
            do {
                createCaptureSession()
                try configCaptureDevices()
                try configDeviceInputs()
                try configPhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    
    
    func displayPreview(on view:UIView) throws {//shows whats being retrieved from the camara
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer!.frame = view.bounds
        
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {//escaping says that the params can change
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()//gets the phone's image settings
        //settings.flashMode =
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    
}
extension CameraController {
    enum CameraControllerError: Swift.Error {//this is an enum of all the possible errors we may come across.
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    public enum CameraPosition {//camera position is either front or back
        case front
        case back
    }
}
extension CameraController: AVCapturePhotoCaptureDelegate {
    public func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) } // show the error
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)//complete with an image
        }
            
        else {//complete with unknown error and no image
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}

