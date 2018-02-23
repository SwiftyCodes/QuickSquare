
import UIKit
import CHTStickerView

protocol AddtextDelegate:class {
    func addTextDidFinish(_ addTextVC:TestVC)
}

var textGlobal : String?
var textColor : UIColor?
var Font : UIFont?

class TestVC: UIViewController,UITextViewDelegate,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelValue : UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var colors = [AnyObject]()
    var familyNames : NSMutableArray!
    
    var addTextDelegate:AddtextDelegate?
    var textFromAddTextVC : String!
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyNames = (UIFont.familyNames as! NSMutableArray)

        var _: Float = 0.05
        var hue = 0.0
        while hue < 1.0 {
            let color = UIColor(hue: CGFloat(hue), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            colors.append(color)
            
            hue += 0.05
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        labelValue.addGestureRecognizer(tapGesture)
        labelValue.text = "Tap to enter text!"
        
        colorCreation()
        
        
        textView.font = .systemFont(ofSize: 40)
        
        let sampleTapGesture = UITapGestureRecognizer(target: self, action: #selector(TestVC.sampleTapGestureTapped(recognizer:)))
        self.view.addGestureRecognizer(sampleTapGesture)
        
        
        
    }

    func sampleTapGestureTapped(recognizer: UITapGestureRecognizer) {
        print("Hellp")
       textView.becomeFirstResponder()
        textView.isHidden  = false
    }
    
    @IBAction func fontButtonAction(_ sender: Any) {
        
        labelValue.becomeFirstResponder()
        
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        filterCreation()
    }

    
    var itemCount : Int?
    func filterCreation() {
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 55.0
        let buttonHeight: CGFloat = 55.0
        let gapBetweenButtons: CGFloat = 5
        var itemCount = 0
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        for i in 0..<familyNames.count {
            itemCount = i
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.setTitleColor(UIColor.white, for: .normal)
            filterButton.setTitle("ABC", for: .normal)
            filterButton.titleLabel!.font =  UIFont(name: String(describing: familyNames[itemCount]), size: 15)
            filterButton.addTarget(self, action:#selector(FilterTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 5
            filterButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            scrollView.addSubview(filterButton)
            
        }
        scrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+7), height: yCoord)
    }
    
    var filterItem : Int?
    func FilterTapped(sender: UIButton) {
  
        
        let button = sender as UIButton
        filterItem = button.tag
        
        textView.font =  UIFont(name: String(describing: familyNames[button.tag]), size: 40)
        Font = textView.font
        labelValue.font = Font

    }
    
    
    @IBAction func colorButtonAction(_ sender: Any) {
        
        
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        colorCreation()
    }
    
    
    var itemCountColor : Int?
    func colorCreation() {
        
        
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 50.0
        let buttonHeight: CGFloat = 50.0
        let gapBetweenButtons: CGFloat = 5
        var itemCountColor = 0
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        for i in 0..<colors.count {
            itemCountColor = i
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCountColor
            filterButton.setTitleColor(UIColor.white, for: .normal)
            //  filterButton.setTitle("ABC", for: .normal)
            // filterButton.titleLabel!.font =  UIFont(name: String(describing: familyNames[itemCountColor]), size: 15)
            filterButton.backgroundColor = colors[itemCountColor] as? UIColor
            // filterButton.setTitleColor(colors[itemCountColor] as? UIColor, for: .normal)
            filterButton.addTarget(self, action:#selector(FilterColorTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 25
            filterButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            scrollView.addSubview(filterButton)
            
        }
        scrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCountColor+3), height: yCoord)
    }

    
    func FilterColorTapped(sender: UIButton) {
        let button = sender as UIButton
        //filterItem = button.tag
        
        textView.textColor =  colors[button.tag] as? UIColor
        textColor = textView.textColor
        labelValue.textColor = textColor
      //  imageFromAddTextVC = returnFinalImage()
        
    }


    
    @IBAction func cross(_ sender:UIButton) {
     
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneAction(_ sender:UIButton) {

        if manageDone  {
            
            if addTextDelegate != nil {
                
                addTextDelegate?.addTextDidFinish(self)
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        manageDone = false
    }
    
    
    func handleTap(sender: UITapGestureRecognizer) {
        
        
        textView.isHidden = false
        textView.becomeFirstResponder()
        labelValue.isHidden = true
        textView.backgroundColor = .clear
 
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
        
        
    {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    var manageDone = false
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        manageDone = true
        
       // labelValue.text =
        textFromAddTextVC = textView.text!
        textGlobal = textFromAddTextVC
        textView.isHidden = true
        labelValue.isHidden = false
  
    }
    
    
    @objc func textView(_ shouldChangeTextIntextView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if(text == "\n") {
            textView.resignFirstResponder()
            labelValue.text = textView.text!
            textFromAddTextVC = labelValue.text
            textGlobal = textFromAddTextVC
            
            return false
        }
        return true
    }
 
}
