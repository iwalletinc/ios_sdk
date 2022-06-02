//
//  ViewController.swift
//  iWalletScannerExample
//
//  Created by Eugene Kus on 01.02.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView! {
        didSet {
            checkImageView.layer.borderWidth = 2
            checkImageView.layer.cornerRadius = 6
            checkImageView.layer.borderColor = UIColor(named: "iWalletMain")!.cgColor
        }
    }
    @IBOutlet weak var depositButton: UIButton! {
        didSet {
            depositButton.layer.cornerRadius = 6
        }
    }
    
    let accessToken = "2aa6e5a8-9202-4984-ae0d-1f438390429f"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Deposit Check"
        setUpUI()
    }
    
    func setUpUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showScanner))
        cameraImage.addGestureRecognizer(tap)
        checkImageView.addGestureRecognizer(tap)
        cameraImage.isUserInteractionEnabled = true
        checkImageView.isUserInteractionEnabled = true
        amountTextField.addDoneButtonOnKeyboard()
        phoneTextField.addDoneButtonOnKeyboard()
        noteTextField.addDoneButtonOnKeyboard()
        
    }
    
    @IBAction func depositButtonPressed(_ sender: Any) {
        
    }
    
    @objc func showScanner() {
        guard let scanCheckCaptureViewController = UIStoryboard(name: "iWalletScanner", bundle: nil).instantiateViewController(withIdentifier: "ScanCheckCaptureViewController") as? ScanCheckCaptureViewController else { return }
        scanCheckCaptureViewController.amount = Double(amountTextField.text ?? "")
        scanCheckCaptureViewController.phone = phoneTextField.text
        scanCheckCaptureViewController.note = noteTextField.text
        scanCheckCaptureViewController.accessToken = accessToken
        scanCheckCaptureViewController.delegate = self
        navigationController?.pushViewController(scanCheckCaptureViewController, animated: true)
    }
    
}

extension ViewController: iWalletScanner {
    func capturedImage(image: UIImage, gid: String, responceMessage: String) {
//        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: .portrait)
        cameraImage.isHidden = true
        checkImageView.image = image
        checkImageView.contentMode = .scaleToFill
    }
}

