//
//  ScanCheckCaptureViewController.swift
//  iWallet
//
//  Created by Eugene Kus on 04.01.2022.
//  Copyright © 2022 Suffescom. All rights reserved.
//

import UIKit
import iWalletScannerManager
import IWalletApi

protocol iWalletScanner: class {
    func capturedImage(image: UIImage, gid: String, responceMessage: String)
}

class ScanCheckCaptureViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var topBorderHeight: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    var delegate: iWalletScanner?
    let cameraManager = CameraManager()
    var isFlashOn = true
    var isZoomOn = false
    
    var phone: String?
    var amount: Double?
    var note: String?
    var accessToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.shouldRespondToOrientationChanges = false
        cameraManager.flashMode = .on
        cameraManager.shouldEnablePinchToZoom = true
        cameraManager.addPreviewLayerToView(self.cameraView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        AppUtility.lockOrientation(.all)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func captureButtonPressed(_ sender: Any) {
        cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .failure:
                    return
                case .success(let content):
                    if let capturedImage = content.asImage {
                        if let base64 = capturedImage.jpegData(compressionQuality: 0.1)?.base64EncodedString() {
                            self.getPaymentIntent(base64Image: base64, image: capturedImage)
                        } else {
                            return
                        }
                    } else {
                        return
                    }
            }
        })
    }
    
    @IBAction func flashButtonPressed(_ sender: Any) {
        if cameraManager.hasFlash {
            if isFlashOn {
                cameraManager.flashMode = .off
                flashButton.setImage(UIImage(named: "flashOff"), for: .normal)
            } else {
                cameraManager.flashMode = .on
                flashButton.setImage(UIImage(named: "flashOn"), for: .normal)
            }
            isFlashOn.toggle()
        }
    }
    
    @IBAction func zoomButtonPressed(_ sender: Any) {
        if isZoomOn {
            cameraManager.zoom(1)
            zoomButton.setImage(UIImage(named: "zoomIn"), for: .normal)
        } else {
            cameraManager.zoom(2)
            zoomButton.setImage(UIImage(named: "zoomOut"), for: .normal)
        }
        isZoomOn.toggle()
    }
    
    func getPaymentIntent(base64Image: String, image: UIImage) {
        if let accessToken = accessToken {
            activityIndicator.startAnimating()
            iWalletScannerAPiManager.shared.getPaymentIntentEndPoint(phone: phone ?? "", amount: amount ?? 0, checkImage: base64Image, note: note ?? "", access: accessToken) { (result) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    switch result {
                    case .success(let data):
                        self.delegate?.capturedImage(image: image, gid: data.gid, responceMessage: data.message)
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            print("No access token")
            self.navigationController?.popViewController(animated: true)
        }
    }
    }
