

import UIKit

var MutableArray : NSMutableArray = []

protocol StickerCollectionDelegate:class {
    func stickerSelectionDidFinish(_ stickerCollectionVC:StickerCollectionVC)
}


class StickerCollectionVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var collectioViewOutlet: UICollectionView!
    @IBOutlet weak var ViewCollection: UIView!
    @IBOutlet weak var slideButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    //Constraints Outlet TableView
    
    @IBOutlet weak var TBLeadingConst: NSLayoutConstraint!
    
    var menuShowing = false
    
    var wallpaperTableImageArray = ["cat-emoji","cloth","emoji","flower-crown","fruits","golden-elements","panda","sweet-smiley","Thought-bubbles","nosetable","eyeTable"]
    
    var emoticonsCollectionImageArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21"]
    
    
    var stickerCollectionVCDelegate:StickerCollectionDelegate?
    var selectedCells : NSMutableArray = []
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectioViewOutlet.allowsMultipleSelection=true

        TBLeadingConst.constant = -200
        
        slideButton.addTarget(self, action: #selector(StickerCollectionVC.showMenu), for: .touchUpInside)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

//        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
//        ViewCollection.addGestureRecognizer(tapgesture)
        
    }
    
    
    
    //MARK: SHOW MENU
    
     func showMenu(_ sender:UIButton) {
        
        if menuShowing {
           
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
     
        }else {
          
            TBLeadingConst.constant = 0
            slideButton.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
               self.view.backgroundColor = Methods().UIColorFromRGB(rgbValue: 0xb5b5b5)
               self.topView.backgroundColor = Methods().UIColorFromRGB(rgbValue: 0xb5b5b5)
                self.view.layoutIfNeeded()
            })
        }
        
        menuShowing = !menuShowing
    }
    
    //MARK: GESTURE'S

    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            
            TBLeadingConst.constant = 0
            slideButton.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = Methods().UIColorFromRGB(rgbValue: 0xb5b5b5)
                self.topView.backgroundColor = Methods().UIColorFromRGB(rgbValue: 0xb5b5b5)
                self.view.layoutIfNeeded()
            })
            
        }
        else {
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    
    func tapGesture(sender:UITapGestureRecognizer) {

        TBLeadingConst.constant = -200
        slideButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor.white
            self.topView.backgroundColor = UIColor.white
            self.view.layoutIfNeeded()
        })
        
    }
    
    //MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wallpaperTableImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! StickerTableCell
        
        cell.wallpaperImageView.image = UIImage(named: wallpaperTableImageArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.red
        
        if indexPath.row == 0 {
            
            emoticonsCollectionImageArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })

        }
        
        if indexPath.row == 1 {
            
            emoticonsCollectionImageArray = ["cloth1","cloth2","cloth3","cloth4","cloth5","cloth6","cloth7","cloth8","cloth9","cloth10","cloth11","cloth12","cloth13","cloth14","cloth15","cloth16","cloth17"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })

            
        }
        
        if indexPath.row == 2 {
            
            emoticonsCollectionImageArray = ["E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12","E13","E14","E15","E16"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        if indexPath.row == 3 {
            
            emoticonsCollectionImageArray = ["f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","f13","f14","f15","f16","f17","f18","f19","f20"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        if indexPath.row == 4 {
            
            emoticonsCollectionImageArray = ["c1","c2","c3","c4","c5","c6","c7","c8","c9","c10","c11","c12","c13","c14","c15","c16","c17","c18","c19"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        
        if indexPath.row == 5 {
            
            emoticonsCollectionImageArray = ["g1","g2","g3","g4","g5","g6","g7","g8","g9","g10","g11","g12","g13","g14","g15","g16","g17","g18","g19","g20","g21","g22"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        if indexPath.row == 6 {
            
            emoticonsCollectionImageArray = ["t35","t36","t37","t38","t39","t40","t41","t42","t43","t44","t45","t46","t47","t48","t49","t50","t51","t52","t53","gt54"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        if indexPath.row == 7 {
            
            emoticonsCollectionImageArray = ["smiley1","smiley2","smiley3","smiley4","smiley5","smiley6","smiley7","smiley8","smiley9","smiley10","smiley11","smiley12","smiley13","smiley14","smiley15","smiley16","smiley17","smiley18","smiley19","smiley20","smiley21","smiley22","smiley23","smiley24","smiley25","smiley26","smiley27","smiley28","smiley29","smiley30","smiley31","smiley32"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        if indexPath.row == 8 {
            
            emoticonsCollectionImageArray = ["q1","q2","q3","q4","q5","q6","q7","q8","q9","q10","q11","q12","q13","q14","q15","q16","q17","q18","q19","q20","q21","q22","q23","q24"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        if indexPath.row == 9 {
            
            emoticonsCollectionImageArray = ["Nose1","Nose2","Nose3","Nose4","Nose5","Nose6","Nose7","Nose8","Nose9","nose10","Nose11","nose12","nose13","nose14","nose15"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
        
        if indexPath.row == 10 {
            
            emoticonsCollectionImageArray = ["eye1","eye2","eye3","eye4","eye5","eye6","eye7","eye8","eye9","eye10","eye11","eye12","eye13","eye14","eye15","eye16","eye17","eye18","eye19","eye20","eye21","eye23","eye24","eye25","eye26","eye27","eye28","eye30","eye31","eye32","eye33","eye34","eye35","eye36","eye37","eye38","eye39","eye40","eye41"]
            
            TBLeadingConst.constant = -200
            slideButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.white
                self.topView.backgroundColor = UIColor.white
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.4, animations: {
                self.collectioViewOutlet.reloadData()
                self.view.layoutIfNeeded()
            })
            
            
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
   //     let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
    //    cellToDeSelect.contentView.backgroundColor = UIColor.clear
 //   }
    
    
    //MARK: CollectionView Delegate Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoticonsCollectionImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! StickerCollectionViewCell

        
        cell.emoticonImageView.image = UIImage(named: emoticonsCollectionImageArray[indexPath.row])
        
        return cell
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedCells.add((UIImage(named: emoticonsCollectionImageArray[indexPath.row]))!)
        
        
        
        cell?.backgroundColor = Methods().UIColorFromRGB(rgbValue: 0xeeeeee)
        MutableArray = selectedCells

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        selectedCells.remove((UIImage(named: emoticonsCollectionImageArray[indexPath.row]))!)
        MutableArray = selectedCells

    }

    @IBAction func crossAction(_ sender:UIButton) {

        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func doneSelectingImages(_ sender:UIButton) {

         MutableArray = selectedCells
 
        if stickerCollectionVCDelegate != nil {
            
            stickerCollectionVCDelegate?.stickerSelectionDidFinish(self)
        }
        
        self.dismiss(animated: true, completion: nil)

    }
    
   // let appDelegate = UIApplication.shared.delegate as! AppDelegate


}
