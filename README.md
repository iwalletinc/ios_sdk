# ios_sdk

iWallet scanner SDK - V1.4.0

Installation

• Move the iWalletScannerSDK folder to your project. 

• Declare a ViewController:
```
UIStoryboard(name: "iWalletScanner", bundle: nil).instantiateViewController(withIdentifier: "ScanCheckCaptureViewController") as? ScanCheckCaptureViewController 
```
• Assign amount, phone, accessToken (your unique token given to you by iWallet), note (if needed) to ScanCheckCaptureViewController
```
scanCheckCaptureViewController.amount = Double(amountTextField.text ?? "")
scanCheckCaptureViewController.phone = phoneTextField.text
scanCheckCaptureViewController.note = noteTextField.text
scanCheckCaptureViewController.accessToken = accessToken
```

• Connect the delegate to your ViewController:
```
scanCheckCaptureViewController.delegate = self
```

• Create an extension iWalletScanner and declare there a capturedImage function. 
You will get there regular image captured by scanner, gid string and response message from iWallet Api (about successful gid created)

```
extension ViewController: iWalletScanner {
    func capturedImage(image: UIImage, gid: String, responceMessage: String) {
    }
}
```

• Add this code to your AppDelegate to make it possible to lock screen orientation for scanner screen
```
var orientationLock = UIInterfaceOrientationMask.all

func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return self.orientationLock
}
```
• Add this property to your Info.plist file Privacy - Camera Usage Description with value We need access to your camera to provide a scan

• Use this Api to finalise your Check transaction - /api/v1/public/check21/finalize/{id} Api docs - https://staging.iwallet.com/api-docs/index.html


Capture 

When user captures the image sdk sends base64 of the image with amount, note, phone to iWallet api to create a gid String. After response sdk calls delegate method
capturedImage where you can get your gid String, response message and original image. If error occurs during scan and after - sdk returns to previous view controller and logs error message.  
