import UIKit
import GPUImage

class GPUCameraVC: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var front_rearCamButton: UIButton!
    
    
    var stillCamera : GPUImageStillCamera!
    var image : GPUImageView!
    var GpuFilter : GPUImageFilter!
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeCamera()
        
    }
    
    func initializeCamera() {
        
        stillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPresetPhoto, cameraPosition: .back)
        
        stillCamera.outputImageOrientation = .portrait
        image = GPUImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height - bottomView.frame.size.height))
        
        GpuFilter = GPUImageSaturationFilter()
        
        self.view.addSubview(image)
        
        self.view.bringSubview(toFront: front_rearCamButton)
        stillCamera.addTarget(GpuFilter)
        GpuFilter.addTarget(image)
        stillCamera.startCapture()
        
    }
    
  
    @IBAction  func captureButtonAction(_ sender:UIButton) {
        
        let vc: QuickSquareVC? = self.storyboard?.instantiateViewController(withIdentifier: "QuickSquareVC") as? QuickSquareVC
        
        vc?.imageOnQuickSquare = screenshot()
        
        self.present(vc!, animated: true, completion: nil)
    
    }
    
    var cameraToggle = false
    
    @IBAction func frontBackCameraAction(_ sender: UIButton) {
        
        if cameraToggle {
            
            UIView.transition(with: image, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.stillCamera.rotateCamera()
               
            }, completion: { _ in })
            
        }else {
            
            UIView.transition(with: image, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.stillCamera.rotateCamera()
              
            }, completion: { _ in })
            
        }
        cameraToggle = !cameraToggle
   
    }
    
    @IBAction func crossButtonAction(_ sender:UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.image.bounds.size, false, UIScreen.main.scale)
        self.image.drawHierarchy(in: self.image.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }


}
