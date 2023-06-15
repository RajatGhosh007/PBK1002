//
//  PaymentReceipt.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 16/05/23.
//

import UIKit

class PaymentReceipt: BaseViewController {
    
    @IBOutlet weak var collVWReceipt: UICollectionView!
    
     var paymentReceiptViewModel =  PaymentReceiptViewModel()
    private var usertViewModel = UserViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  self.navigationController?.navigationBar.topItem?.title = "Payment Receipts"
        
        self.addSlideMenuButton()
        setupUI()
       
        
     
        if (NetworkState().isInternetAvailable) {
      //     pageLoadFun()
            paymentReceiptViewModel.demoData()
        }else{
           self.displayAlert(title:Constant.AlertInfo.TITLE, message:Constant.AlertInfo.NO_NETWORK)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
     //   self.navigationController?.navigationBar.topItem?.title = "Payment Receipts"
     
        
    }
    
    private func setupUI() {
        
       
        self.collVWReceipt.register(UINib(nibName: "CustCellPaymentReceipt", bundle: nil), forCellWithReuseIdentifier: "CustCellPaymentReceipt")
        self.collVWReceipt.delegate = self
        self.collVWReceipt.dataSource = self
        
        
     
    }
    
    
    
    func pageLoadFun(){
        
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        
        let paramsForHome = [String:Any]()
        self.showLoader()
        
        paymentReceiptViewModel.getPaymentReceiptListWithAccessToken(ParamsInput: paramsForHome, token: accessToken, urlName:Constant.API_NAME.PAYMENTS, methodType: "GET") { [weak self] _, success in
            
            if success {
                print("Succes  success ")
               DispatchQueue.main.async {
                   self?.hideLoader()
                    self?.collVWReceipt.reloadData()
                    
                }
            }
            
        } fail: {[weak self] _,_,_ in
           self?.refreshAccessTokenAPI()
        }
  
        
    }
    
    func refreshAccessTokenAPI(){
        
        let refreshToken = UserDefaults.standard.string(forKey: "refreshTokenKey")  ?? ""
        let paramsForHome = [String:Any]()
        
        usertViewModel.getAccessTokenWithRefreshToken(ParamsInput: paramsForHome, token: refreshToken, urlName: Constant.API_NAME.REFRESH, methodType:"POST") { [weak self] _, success  in
            self?.pageLoadFun()
        } fail: { [weak self] _,_,_ in
            self?.hideLoader()
            self?.forwrdTOLogINPage()
        }

        
    }
    
    
    func forwrdTOLogINPage(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }


}

extension PaymentReceipt: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     //   return 40
        
        return self.paymentReceiptViewModel.numberOrRows()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
        guard let cell = collVWReceipt.dequeueReusableCell(withReuseIdentifier:"CustCellPaymentReceipt", for: indexPath) as? CustCellPaymentReceipt ,let receiptInfo = self.paymentReceiptViewModel.getReceiptInfo(index: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        cell.setReceiptInfo(receiptInfo: receiptInfo, atIndex: indexPath)
        return cell
      
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let contentSize = (UIScreen.main.bounds.size.width - 20 - 20  ) * 0.5 - 5
 
        return  CGSize(width: contentSize , height:80)
       // return  CGSize(width: 180, height:80)

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let receiptInfo = self.paymentReceiptViewModel.getReceiptInfo(index: indexPath.row)
        
        self.paymentReceiptViewModel.downloadImageFromURL(reciptInfo:receiptInfo)
        
        
    }
    
    
    
    
   
    /*
     
     
     
     @IBAction func DownloadAttachment(_ sender: Any) {
       let  imagestring = Constant.PersonalDetails.strDeliveryAttach
      if let url = URL(string: imagestring){
         if let data = try? Data(contentsOf: url){
             if let image = UIImage(data: data) {
            
                
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }

                    //MARK: - Add image to Library
                    
                    
                 }
             }
        
         
         
     }
     
     
     @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
         if let error = error {
             // we got back an error!
             showAlertWith(title: "Save error", message: error.localizedDescription)
         } else {
             showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
         }
     }

     
     func showAlertWith(title: String, message: String){
         let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "OK", style: .default))
         present(ac, animated: true)
     }
     */
    
}
    
