//
//  GalleryListSortBy.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 25/05/23.
//

import UIKit

protocol GalleryListSortByDelegate : AnyObject { 
    
  //  func forwardToNextPageFromForgetPassword(inputEmailID:String)
    func dismissPopUpView()
}

class GalleryListSortBy: BaseViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    weak var delegate: GalleryListSortByDelegate?
    
    @IBOutlet weak var outsideContentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       viewContainer.roundCornersSpecific(corners: [.topLeft,.topRight], radius: 30.0)
        
        
     
        
    }
   
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            
            if touch.view == outsideContentView {
                
                delegate?.dismissPopUpView()
            }
           
               
            }
        
    }

}
