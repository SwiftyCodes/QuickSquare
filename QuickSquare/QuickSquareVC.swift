import UIKit
import AVFoundation
import CHTStickerView
import TOCropViewController
import GPUImage
 var currentstickerTag1 = 1800
class QuickSquareVC: UIViewController,CHTStickerViewDelegate,TOCropViewControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,StickerCollectionDelegate,AddtextDelegate {
    
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var backImageView:UIImageView!
    @IBOutlet weak var frontImageView:UIImageView!
    @IBOutlet weak var optionScrollView: UIScrollView!
    @IBOutlet weak var filterScrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sliderTextFieldOutlet: UISlider!
 
    var imageOnQuickSquare : UIImage!
    
    var adjustImageArray = ["rotate-R","rotate-L","flip-H","flip-V","crop","sticker","backgrounds","snapChat","text","stickerC","filter"]
    
    var frameImageArray = ["frames-4","frames-5","frames-7","frames-8"]
    
    var stickerImageArray = ["img1","img2","img3","img4","img6","img7","img8","img9","img10","img11","img12","img13","img14","img15","img16","img17","img18","img19","img20","img21","img22","img23","img24","img25","img26","img27","img28","img29"]
    
    var backGroundImageArray = ["bg1","bg2","bg3","bg4","bg5","bg6","bg7","bg8","bg9","bg10","bg11","bg12","bg13","bg14","bg15","bg16","bg17","bg18","bg19","bg20","bg21","bg22","bg23","bg24","bg25","bg26","bg27","b54"]
    
    var aCIImage = CIImage();
    var gaussianBlurFilter: CIFilter!;
    var context = CIContext();
    var outputImage = CIImage();
    var newUIImage = UIImage();
    var finalImage = UIImage()
    
    var currentstickerTag=1700;

    let screenSize: CGRect = UIScreen.main.bounds
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        backImageView.frame = AVMakeRect(aspectRatio: (imageOnQuickSquare?.size)!, insideRect: backImageView.bounds)
        backImageView.image = imageOnQuickSquare
        
         frontImageView.frame = AVMakeRect(aspectRatio: (imageOnQuickSquare?.size)!, insideRect: frontImageView.bounds)
        frontImageView.image = imageOnQuickSquare
        
        masking()
        
        let aUIImage = backImageView.image;
        let aCGImage = aUIImage?.cgImage;
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil);
        
        //DiscBlur()
        
        adjustScrollContents()
        GPUScrollContents()
        
        textField.isHidden = true
        sliderTextFieldOutlet.isHidden = true
        
        labelValue.isHidden = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateGesture))
        
        labelValue.addGestureRecognizer(panGesture)
        labelValue.addGestureRecognizer(pinchGesture)
        labelValue.addGestureRecognizer(rotateGesture)
        
        labelValue.font = labelValue.font.withSize(40)
        
       // DiscBlur()
        

    }

    
    func masking() {
        
        let maskLayer = CALayer()
        maskLayer.frame = frontImageView.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: frontImageView.bounds.insetBy(dx: CGFloat(5), dy: CGFloat(5)), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 15
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowColor = UIColor.black.cgColor
        frontImageView.layer.mask = maskLayer
        
    }

    func DiscBlur() {
        
       // frontImageView.image = returnFinalImage()
        gaussianBlurFilter = CIFilter(name: "CIBoxBlur");
        gaussianBlurFilter.setValue(aCIImage, forKey: "inputImage")
        
        gaussianBlurFilter.setValue(NSNumber(value: 40.0), forKey: "inputRadius");
        outputImage = self.gaussianBlurFilter.outputImage!;
        let imageRef = self.context.createCGImage(self.outputImage, from: self.outputImage.extent)
        
        self.newUIImage = UIImage(cgImage: imageRef!)
        self.backImageView.image = self.newUIImage;
    }
 
    //ADJUST Scroll Creation
    var adjustSubToolsScrollViewCount = 0
    func adjustScrollContents() {
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 45.0
        let buttonHeight: CGFloat = 45.0
        let gapBetweenButtons: CGFloat = 5
        
        for i in 0..<adjustImageArray.count{
            adjustSubToolsScrollViewCount = i
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = adjustSubToolsScrollViewCount
            filterButton.backgroundColor = UIColor.clear
            filterButton.setTitleColor(UIColor.white, for: .normal)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.showsTouchWhenHighlighted = true
            let myimage = UIImage(named: adjustImageArray[adjustSubToolsScrollViewCount])
            filterButton.setImage(myimage, for: .normal)
            filterButton.addTarget(self, action:#selector(AdjustsActionTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 5
            filterButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            optionScrollView.addSubview(filterButton)
            
        }
        optionScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(adjustSubToolsScrollViewCount+3), height: yCoord)
        
    }

        
    var filterSliderValue : Int!
    var beforeEditingImage : UIImage?
    var textFieldActive = false
    var oneSticker = false
    func AdjustsActionTapped(sender:UIButton) {
        
        filterSliderValue = sender.tag
        
        switch sender.tag {
            
        case 0:
            
            frontImageView.image = Methods().rotateImageClockWise(theImage: frontImageView.image!, imageView:  frontImageView)
            
        case 1:
            
             frontImageView.image = Methods().rotateImageAntiClockWise(theImage: frontImageView.image!, imageView: frontImageView)
            
        case 2:
 
            frontImageView.image = Methods().flipImageOnVerticalAxis(theImage: frontImageView.image!, imageView:  frontImageView)
 
            
        case 3:
            
            frontImageView.image = Methods().flipImageOnHorizontalAxis(theImage: frontImageView.image!, imageView:  frontImageView)
            
        case 4:
   
            presentCropperController()
            
        case 5:

            let subViews = self.filterScrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            
            stickerScrollContents()
            
        case 6:
            
            let subViews = self.filterScrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            
            backGroundScrollContents()
            
        case 7:
        
              textFieldActive = true
              textField.isHidden = false
              sliderTextFieldOutlet.isHidden = false
              textField.becomeFirstResponder()

            
        case 8:
  
             let popup: TestVC? = self.storyboard?.instantiateViewController(withIdentifier: "TestVC") as? TestVC
            popup?.addTextDelegate = self
            popup?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(popup!, animated: true, completion: nil)
            
        case 9:

            let vc: StickerCollectionVC? = self.storyboard?.instantiateViewController(withIdentifier: "StickerCollectionVC") as? StickerCollectionVC

            vc?.stickerCollectionVCDelegate = self
            self.present(vc!, animated: true, completion: nil)
            
        case 10:

            let subViews = self.filterScrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            
            GPUScrollContents()

        default:
            
            break
       
        }
   
    }

    //MARK: CROPPER
    func presentCropperController() {
        
        let imageView = UIImageView(image: frontImageView.image)
        _ = self.view.convert(imageView.frame, to: self.view)
        let cropViewController = TOCropViewController(image: frontImageView.image!)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: { _ in })
    }
    
    
    
    @objc(cropViewController:didCropToImage:withRect:angle:) func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {

        frontImageView.image = image
        frontImageView.contentMode = .scaleAspectFill

        cropViewController.dismiss(animated: true, completion: nil)
    }

    //MARK: STICKERS
    var StickerItem = 0
    func stickerScrollContents() {
        
        filterScrollView.backgroundColor = Methods().UIColorFromRGB(rgbValue: 0xeeeeee)
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 45.0
        let buttonHeight: CGFloat = 45.0
        let gapBetweenButtons: CGFloat = 5
        
        for i in 0..<stickerImageArray.count{
            StickerItem = i
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = StickerItem
            filterButton.backgroundColor = UIColor.clear
            filterButton.setTitleColor(UIColor.white, for: .normal)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.showsTouchWhenHighlighted = true
            let myimage = UIImage(named: stickerImageArray[StickerItem])
            filterButton.setImage(myimage, for: .normal)
            filterButton.addTarget(self, action:#selector(StickerActionTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 5
            filterButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            filterScrollView.addSubview(filterButton)
            
        }
        filterScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(StickerItem+4), height: yCoord)
        
    }
    var StickerIntArray = [Int]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var stickerViewStick : CHTStickerView!
    func StickerActionTapped(sender:UIButton) {

        let testView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(100), height: CGFloat(100)))
        testView.contentMode = .scaleAspectFit
        testView.clipsToBounds = true
        testView.image = UIImage(named: stickerImageArray[sender.tag])//adjustImageArray[i] as? UIImage
        stickerViewStick = CHTStickerView(contentView: testView)
        stickerViewStick?.center = view.center
        stickerViewStick?.delegate = self
        stickerViewStick.tag = sender.tag
        stickerViewStick.tag = currentstickerTag;
        currentstickerTag += 1
        
        StickerIntArray.append(stickerViewStick.tag)

        stickerViewStick?.setImage(UIImage(named: "Close"), for: CHTStickerViewHandler.close)
        stickerViewStick?.setImage(UIImage(named: "Rotate"), for: CHTStickerViewHandler.rotate)
        stickerViewStick?.setImage(UIImage(named: "Flip")!, for: CHTStickerViewHandler.flip)
        stickerViewStick?.setHandlerSize(20)
        stickerViewStick?.showEditingHandlers = false
        contentView.addSubview(stickerViewStick!)
        
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateGesture))
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        
     //   stickerViewStick.addGestureRecognizer(panGesture)
        stickerViewStick.addGestureRecognizer(pinchGesture)
        stickerViewStick.addGestureRecognizer(rotateGesture)
        stickerViewStick.addGestureRecognizer(tapgesture)
    }
    
    var deleteImageView : CHTStickerView!
    var tagValue : Int?
    func tapGesture(sender:UITapGestureRecognizer) {
        let tag:Int = (sender.view?.tag)!
        tagValue = tag
        
        deleteImageView = view.viewWithTag(tag) as! CHTStickerView
        let alert = UIAlertController(title: "", message: "Do you want to delete it? ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
            
            self.deleteImageView.removeFromSuperview()
            
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func saveButtonAction(_ sender:UIButton) {
    
//        UIImageWriteToSavedPhotosAlbum(returnFinalImage(), nil, nil, nil)
//        let alert = UIAlertController(title: "Success", message: "Your Images has been saved to the gallery", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
        otherSharing()

        
    }
    
    func otherSharing() {
        
        let activityItem: [AnyObject] = [returnFinalImage() as AnyObject]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
    }
    


    
    //MARK: BACKGROUNDS
    
    var backgroundItem = 0
    func backGroundScrollContents() {
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 45.0
        let buttonHeight: CGFloat = 45.0
        let gapBetweenButtons: CGFloat = 5
        
        for i in 0..<backGroundImageArray.count{
            backgroundItem = i
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = backgroundItem
            filterButton.backgroundColor = UIColor.clear
            filterButton.setTitleColor(UIColor.white, for: .normal)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.showsTouchWhenHighlighted = true
            let myimage = UIImage(named: backGroundImageArray[backgroundItem])
            filterButton.setImage(myimage, for: .normal)
            filterButton.addTarget(self, action:#selector(backgroundActionTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 5
            filterButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            filterScrollView.addSubview(filterButton)
            
        }
        filterScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(backgroundItem+4), height: yCoord)
        
    }

    func backgroundActionTapped(sender:UIButton) {
        
        backImageView.image = UIImage(named: backGroundImageArray[sender.tag])
        
    }

    //MARK: TextField 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        
        textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    func performAction() {
        
        textFieldActive = false
     //   textField.isUserInteractionEnabled = false
        
        if textField.text == "" {
           
            textField.isHidden = true
            sliderTextFieldOutlet.isHidden = true
        }
        
         sliderTextFieldOutlet.isHidden = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        
        textField.addGestureRecognizer(panGesture)
    
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textFieldActive {
            
            return true
            
        }else {
            
            return false
            
        }
   
    }
    
    @IBAction func SliderAction(_ sender: UISlider) {
        
        textField.alpha = CGFloat(sliderTextFieldOutlet.value)
        
    }

    var GPUFilterImageArray = ["echo","cruz1","flume","roast","tiki","athens","oak1","waves","tokyo","kayak","lincolun1","rio","newport","nova","market1","sketch1","radio","marid1","flux","retra","organic","nomad1","golden","fairy1","alya","moissa","luma","electra","cora","iris1"]
    
    //GPUImage FIlters
    var GPUSubToolsScrollViewCount = 0
    func GPUScrollContents() {
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 55.0
        let buttonHeight: CGFloat = 55.0
        let gapBetweenButtons: CGFloat = 5
        
        for i in 0..<GPUFilterImageArray.count{
            GPUSubToolsScrollViewCount = i
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = GPUSubToolsScrollViewCount
            filterButton.backgroundColor = UIColor.clear
            filterButton.setTitleColor(UIColor.white, for: .normal)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.showsTouchWhenHighlighted = true
            let myimage = UIImage(named: GPUFilterImageArray[GPUSubToolsScrollViewCount])
            filterButton.setImage(myimage, for: .normal)
            filterButton.addTarget(self, action:#selector(GPUActionTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 5
            filterButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            filterScrollView.addSubview(filterButton)
            
        }
        filterScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(GPUSubToolsScrollViewCount+4), height: yCoord)
        
        beforeEditingImage = frontImageView.image
        
    }

    
    var filterItem : Int?
    func GPUActionTapped(sender: UIButton) {

        let button = sender as UIButton
        filterItem = button.tag
 
        
        switch button.tag {
            
        case 0:
            
            let AmatorkaFilter = GPUImageAmatorkaFilter()
            
            let quickFilteredImage: UIImage? = AmatorkaFilter.image(byFilteringImage: beforeEditingImage)
            
           

            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                 self.frontImageView.image = quickFilteredImage
                            }
            })
   
            
        case 1:
            
            let EktikateFilter = GPUImageMissEtikateFilter()
            
            let quickFilteredImage: UIImage? = EktikateFilter.image(byFilteringImage: beforeEditingImage)
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

    
        case 2:
            
            let SepiaFilter = GPUImageSepiaFilter()
            
            let quickFilteredImage: UIImage? = SepiaFilter.image(byFilteringImage: beforeEditingImage)
            
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })
    
        case 3:
            
            let SaturationFilter = GPUImageSaturationFilter()
            SaturationFilter.saturation = 2.0
            
            let quickFilteredImage: UIImage? = SaturationFilter.image(byFilteringImage: beforeEditingImage)
            
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

  
        case 4:
            
            let BrightnessFilter = GPUImageBrightnessFilter()
            BrightnessFilter.brightness = -0.2
            
            let quickFilteredImage: UIImage? = BrightnessFilter.image(byFilteringImage: beforeEditingImage)
            
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })
  
            
        case 5:
            
            let BrightnessFilter = GPUImageBrightnessFilter()
            BrightnessFilter.brightness = 0.3
            
            let quickFilteredImage: UIImage? = BrightnessFilter.image(byFilteringImage: beforeEditingImage)
            
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

  
        case 6:
            
            let ToonFilter = GPUImageToonFilter()
            ToonFilter.threshold = 0.5
            
            let quickFilteredImage: UIImage? = ToonFilter.image(byFilteringImage: beforeEditingImage)
            
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

            
        case 7:
            
            let GrayScaleFilter = GPUImageGrayscaleFilter()
            
            let quickFilteredImage: UIImage? = GrayScaleFilter.image(byFilteringImage: beforeEditingImage)
            
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

 
        case 8:
            
            let HueFilter = GPUImageHueFilter()
            let quickFilteredImage: UIImage? = HueFilter.image(byFilteringImage: beforeEditingImage)
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

            
        case 9:
            
            let SolarizeFilter = GPUImageSolarizeFilter()
            let quickFilteredImage: UIImage? = SolarizeFilter.image(byFilteringImage: beforeEditingImage)
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

            
        case 10:
            
            let toonFilter  = GPUImageToonFilter()
            toonFilter.threshold = 0.5
            let quickFilteredImage: UIImage? = toonFilter.image(byFilteringImage: beforeEditingImage)
            let  HueGpuFilter = GPUImageHueFilter()
            let hueFilteredImage: UIImage? = HueGpuFilter.image(byFilteringImage: quickFilteredImage)
            
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })

 
        case 11:
            
            let SaturationFilter = GPUImageSaturationFilter()
            SaturationFilter.saturation = 2.0
            let quickFilteredImage: UIImage? = SaturationFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageAmatorkaFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })


        case 12:
            
            let BrightnessFilter = GPUImageBrightnessFilter()
            BrightnessFilter.brightness = 0.3
            let quickFilteredImage: UIImage? = BrightnessFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageAmatorkaFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })
  
            
        case 13:
            
            let HueFilter = GPUImageHueFilter()
            HueFilter.hue = 45.0
            let quickFilteredImage: UIImage? = HueFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageAmatorkaFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })

  
            
        case 14:
            
            let SepiaFilter = GPUImageSepiaFilter()
            let quickFilteredImage: UIImage? = SepiaFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageAmatorkaFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })

            
        case 15:
            
            let SketchFilter = GPUImageSketchFilter()
            SketchFilter.edgeStrength = 0.5
            let quickFilteredImage: UIImage? = SketchFilter.image(byFilteringImage: beforeEditingImage)
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

            
        case 16:
            
            let BiletralFilter = GPUImageBilateralFilter()
            BiletralFilter.texelSpacingMultiplier = 10.0
            BiletralFilter.distanceNormalizationFactor = 4.0
            let quickFilteredImage: UIImage? = BiletralFilter.image(byFilteringImage: beforeEditingImage)
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })
            

            
        case 17:
            
            let ToonFilter = GPUImageToonFilter()
            ToonFilter.threshold = 0.5
            let quickFilteredImage: UIImage? = ToonFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageAmatorkaFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })

        case 18:
            
            let PixalleteFilter = GPUImagePixellateFilter()
            PixalleteFilter.fractionalWidthOfAPixel = 0.009
            let quickFilteredImage: UIImage? = PixalleteFilter.image(byFilteringImage: beforeEditingImage)
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

        case 19:
            
            let grayFilter  = GPUImageGrayscaleFilter()
            let quickFilteredImage: UIImage? = grayFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageAmatorkaFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })
            
            
        case 20:
            
            let grayFilter  = GPUImageGrayscaleFilter()
            let quickFilteredImage: UIImage? = grayFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageMissEtikateFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })

            
        case 21:
            
            let grayFilter  = GPUImageGrayscaleFilter()
            let quickFilteredImage: UIImage? = grayFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageToonFilter()
            AmatorkaGpuFilter.threshold = 0.5
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })


            
        case 22:
            
            let SaturationFilter = GPUImageSaturationFilter()
            SaturationFilter.saturation = 1.5
            let quickFilteredImage: UIImage? = SaturationFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageMissEtikateFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })

            
        case 23:
            
            let BrightnessFilter = GPUImageBrightnessFilter()
            BrightnessFilter.brightness = 0.1
            let quickFilteredImage: UIImage? = BrightnessFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageMissEtikateFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })
            
 
            
        case 24:
            
            let BrightnessFilter = GPUImageHueFilter()
            BrightnessFilter.hue = 180.0
            let quickFilteredImage: UIImage? = BrightnessFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageMissEtikateFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })
            

            
        case 25:
            
            let SaturationFilter = GPUImageSaturationFilter()
            SaturationFilter.saturation = 1.5
            
            let quickFilteredImage: UIImage? = SaturationFilter.image(byFilteringImage: beforeEditingImage)
            
            let softEleganceFilter = GPUImageSoftEleganceFilter()
            
            let hueFilteredImage: UIImage? = softEleganceFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })
            
 
        case 26:
            
            let softEleganceFilter = GPUImageSoftEleganceFilter()
            
            let quickFilteredImage: UIImage? = softEleganceFilter.image(byFilteringImage: beforeEditingImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })
            
            
        case 27:
            
            let monoSchoreFilter = GPUImageMonochromeFilter()
            let quickFilteredImage: UIImage? = monoSchoreFilter.image(byFilteringImage: beforeEditingImage)
            
            let softEleganceFilter = GPUImageSoftEleganceFilter()
            
            let hueFilteredImage: UIImage? = softEleganceFilter.image(byFilteringImage: quickFilteredImage)
            frontImageView.image = hueFilteredImage
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = quickFilteredImage
                            }
            })

            
        case 28:
            
            let SharpnessFilter = GPUImageSharpenFilter()
            SharpnessFilter.sharpness = 3.0
            let quickFilteredImage: UIImage? = SharpnessFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageAmatorkaFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })
            
    
        case 29:
            
            let SharpnessFilter = GPUImageSharpenFilter()
            SharpnessFilter.sharpness = 3.0
            let quickFilteredImage: UIImage? = SharpnessFilter.image(byFilteringImage: beforeEditingImage)
            let  AmatorkaGpuFilter = GPUImageMissEtikateFilter()
            let hueFilteredImage: UIImage? = AmatorkaGpuFilter.image(byFilteringImage: quickFilteredImage)
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.frontImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.frontImageView.transform = CGAffineTransform.identity
                                self.frontImageView.image = hueFilteredImage
                            }
            })

            
        default:
            break
        }
        
        
    }

    
    
    
    func returnFinalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(contentView.frame.size, contentView.isOpaque, 0.0)
        contentView.drawHierarchy(in: CGRect(x: CGFloat(contentView.frame.origin.x), y: CGFloat(0), width: CGFloat(contentView.frame.size.width), height: CGFloat(contentView.frame.size.height)), afterScreenUpdates: true)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    
    

    //MARK: GESTURE METHODS

    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        
        frontImageView.bringSubview(toFront: frontImageView)
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        
    }
    
    
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    //MARK : LABEL GESTURES 
    
    func pinchGesture(sender:UIPinchGestureRecognizer) {
        
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        
    }
    
    func panGesture(sender:UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    func rotateGesture(sender:UIRotationGestureRecognizer) {
        
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc func gestureRecognizer(_: UIGestureRecognizer,
                                 shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func backButtonAction(_ sender:UIButton){
        
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: STICKER Delegate Call
    var imagesStickerArray : NSMutableArray = []
    var stickerView: CHTStickerView!
   
    func stickerSelectionDidFinish(_ stickerCollectionVC: StickerCollectionVC) {

       
        for i in 0..<MutableArray.count {
            let testView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(100), height: CGFloat(100)))
            testView.contentMode = .scaleAspectFit
            testView.clipsToBounds = true
            testView.image = MutableArray[i] as? UIImage
            stickerView = CHTStickerView(contentView: testView)
           // stickerView.tag = sender.tag
            stickerView.tag = currentstickerTag1;
            currentstickerTag1 += 1
            stickerView?.center = view.center
            stickerView?.delegate = self
            stickerView?.setImage(UIImage(named: "Close"), for: CHTStickerViewHandler.close)
            stickerView?.setImage(UIImage(named: "Rotate"), for: CHTStickerViewHandler.rotate)
            stickerView?.setImage(UIImage(named: "Flip")!, for: CHTStickerViewHandler.flip)
            stickerView?.setHandlerSize(20)
            stickerView?.showEditingHandlers = false
            contentView.addSubview(stickerView!)
      
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateGesture))
            let tapgesture1 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture1))

            stickerView.addGestureRecognizer(pinchGesture)
            stickerView.addGestureRecognizer(rotateGesture)
            stickerView.addGestureRecognizer(tapgesture1)

        }
        
        MutableArray = []
        
    }
    
    var deleteImageView1 : CHTStickerView!
    var tagValue1 : Int?
    func tapGesture1(sender:UITapGestureRecognizer) {
        let tag1:Int = (sender.view?.tag)!
        tagValue1 = tag1
        
        deleteImageView = view.viewWithTag(tag1) as! CHTStickerView
        let alert = UIAlertController(title: "Alert", message: "You want to delete it ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
            
            self.deleteImageView.removeFromSuperview()
            
        }))

        self.present(alert, animated: true, completion: nil)
        
    }

    //MARK: AddTextVC Delegate Call
    var textFromAddTextVC:String?
    
    func addTextDidFinish(_ addTextVC: TestVC) {

        
        if textGlobal != nil   {
      
                labelValue.isHidden = false
        
                textFromAddTextVC = textGlobal
                labelValue.text = textFromAddTextVC
                labelValue.textColor = textColor
                labelValue.font = Font
                labelValue.font = labelValue.font.withSize(40)
            
        }else {
            
           
        }
    }
    
}
