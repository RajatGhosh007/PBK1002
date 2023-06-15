//
//  GalleryListVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 19/05/23.
//

import UIKit

class GalleryListVC: BaseViewController {
    
    var galleryListViewModel = GalleryListViewModel()
    
    @IBOutlet weak var viewSortBy: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewZip: UIView!
   
    @IBOutlet weak var tblGalleryList: UITableView!
    
    
    var custVwGalleryListSortBy =  GalleryListSortBy()
    var custVwGalleryListFilter =  GalleryListFilter()
    
    //  GalleryListFilter
    let datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        pageLoadFun()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  self.navigationController?.navigationBar.isHidden = true
        viewSortBy.roundCornerWithCornerRadius(cornerRadius: 5,colorBorder: UIColor.gray, borderWidth:1)
        viewFilter.roundCornerWithCornerRadius(cornerRadius: 5,colorBorder: UIColor.gray, borderWidth:1)
        viewZip.roundCornerWithCornerRadius(cornerRadius: 5,colorBorder: UIColor.gray, borderWidth:1)
        // viewZip
    }
    
    
    private func setupUI() {
        
       self.tblGalleryList.register(UINib(nibName: "CustCellGalleryList", bundle: nil), forCellReuseIdentifier: "CustCellGalleryList")
        self.tblGalleryList.delegate = self
        self.tblGalleryList.dataSource = self
        self.tblGalleryList.reloadData()
        
        self.tblGalleryList.rowHeight = UITableView.automaticDimension
        self.tblGalleryList.estimatedRowHeight = 230
        
        /*
             //or if you use class:
              self.collectionView.register(CustCellGalleryList.self, forCellWithReuseIdentifier: cellIdentifier)
        */

        
     
    }
    
    
    func pageLoadFun(){
        
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        
        var paramDict = [String:String]()
      //  self.showLoader()
        
        galleryListViewModel.getGalleryListWithAccessToken(ParamsInput: paramDict, token: accessToken, urlName:Constant.API_NAME.FILES, methodType: "GET") {  _, _ in
            
           // if success {
                print("Succes  success ")
               DispatchQueue.main.async {
                   self.hideLoader()
                   self.tblGalleryList.reloadData()
                    
                }
          //  }
            
        } fail: { _,_,_ in
           //self?.refreshAccessTokenAPI()
        }
  
        
    }
    
    
    func filteFun(){
        
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        
       
        
        var paramDict = [String:String]()
        
        paramDict = ["from_date":"2023-05-25","to_date":"2023-05-25"]
     
      //  self.showLoader()
        
        galleryListViewModel.getFilterListWithAccessToken(paramsInput: paramDict, token: accessToken, urlName:Constant.API_NAME.FILES, methodType: "GET") {  _, _ in
            
           // if success {
                print("Succes  success ")
               DispatchQueue.main.async {
                   self.hideLoader()
                   self.tblGalleryList.reloadData()
                    
                }
          //  }
            
        } fail: { _,_,_ in
           //self?.refreshAccessTokenAPI()
        }
  
        
    }
    
    
    
    // MARK: Display Sort By  Popup
    
    @IBAction func displaySortByPopUP(_ sender: UIButton) {
        self.showSortByPopUP()
    }
    
    
    func showSortByPopUP(){
        
        custVwGalleryListSortBy = GalleryListSortBy(nibName:"GalleryListSortBy", bundle: nil)
        custVwGalleryListSortBy.delegate = self
        
        custVwGalleryListSortBy.view.frame = self.view.bounds
        self.addChild(custVwGalleryListSortBy)
        self.view.addSubview(custVwGalleryListSortBy.view)
       
        
        
    }
    
    @IBAction func displayFilterImagePopUP(_ sender: UIButton) {
        self.showFilterImagePopUP()
    }
    
    
    func showFilterImagePopUP(){
        
        custVwGalleryListFilter = GalleryListFilter(nibName:"GalleryListFilter", bundle: nil)
        custVwGalleryListFilter.delegate = self
        
        custVwGalleryListFilter.view.frame = self.view.bounds
        self.addChild(custVwGalleryListFilter)
        self.view.addSubview(custVwGalleryListFilter.view)
       
        
        
    }
  
    //   var custVwGalleryListFilter =  GalleryListFilter()
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension GalleryListVC: UITableViewDelegate ,UITableViewDataSource  {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // return galleryList.count
        return self.galleryListViewModel.numberOrRows()
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         guard let cell = tblGalleryList.dequeueCell(withType: CustCellGalleryList.self, for: indexPath) as? CustCellGalleryList ,let galleryInfo = self.galleryListViewModel.getGalleryListInfo(index: indexPath.row) else {
                return UITableViewCell()
                
            }
        
        //let galleryInfo = self.galleryListViewModel.getGalleryListInfo(index: indexPath.row)
        
        print("galleryInfo    ",galleryInfo)
            
       
        cell.setGallerytInfo(galleryInfo: galleryInfo, atIndex: indexPath)
        
        
        cell.frame = tblGalleryList.bounds
        cell.layoutIfNeeded()
        cell.collVwGalleryImg.reloadData()
        cell.consHeightImgList.constant   =  cell.collVwGalleryImg.collectionViewLayout.collectionViewContentSize.height
            cell.selectionStyle = .none
            return cell
            
        
        
        
        
        
        
        
    }
      
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //  return 200;//Choose your custom row height
   return  UITableView.automaticDimension
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}


extension GalleryListVC: GalleryListSortByDelegate , GalleryListFilterDelegate  {
    
    func dismissPopUpView(){
        
        custVwGalleryListSortBy.view.removeFromSuperview()
        custVwGalleryListSortBy.delegate = nil
        custVwGalleryListSortBy.removeFromParent()
    }
 
        func dismissPopUpViewFilerVC(){
            
            custVwGalleryListFilter.view.removeFromSuperview()
            custVwGalleryListFilter.delegate = nil
            custVwGalleryListFilter.removeFromParent()
        }
    
    func  displayDatePicker(){
        
       // self.showDatePickerFun()
    }
    
    
    func applyFilter(fromDate:String,toDate:String){
        
        self.filteFun()
        custVwGalleryListFilter.view.removeFromSuperview()
        custVwGalleryListFilter.delegate = nil
        custVwGalleryListFilter.removeFromParent()
    }
   
    
}
    
