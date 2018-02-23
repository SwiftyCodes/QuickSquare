
import UIKit

class BeginVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView : UIImageView!
    
    var collectionViewImages = ["camera","gallery","collage"]
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  
    func masking() {
        
        let maskLayer = CALayer()
        maskLayer.frame = imageView.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: imageView.bounds.insetBy(dx: CGFloat(5), dy: CGFloat(5)), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 15
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowColor = UIColor.black.cgColor
        imageView.layer.mask = maskLayer
        
    }

    
    @IBAction func cameraAction(_ sender: UIButton) {
        
        let vc: GPUCameraVC? = self.storyboard?.instantiateViewController(withIdentifier: "GPUCameraVC") as? GPUCameraVC
        
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    @IBAction func galleryAction(_ sender: UIButton) {
        
//        let vc: QuickSquareVC? = self.storyboard?.instantiateViewController(withIdentifier: "QuickSquareVC") as? QuickSquareVC
//        
//        vc?.imageOnQuickSquare = imageView.image
//        
//        self.present(vc!, animated: true, completion: nil)
        
        openGallary()
        
    }
    
    func openGallary()
    {
        picker?.delegate=self
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let cameraImageis = info[UIImagePickerControllerOriginalImage] as? UIImage
        let vc: QuickSquareVC? = self.storyboard?.instantiateViewController(withIdentifier: "QuickSquareVC") as? QuickSquareVC
        
        if let validVC: QuickSquareVC = vc {
            if let capturedImage = cameraImageis {
                validVC.imageOnQuickSquare = capturedImage
                DispatchQueue.main.async
                    {
                        self.present(validVC, animated: true, completion: nil)
                }
            }
            
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    

}
