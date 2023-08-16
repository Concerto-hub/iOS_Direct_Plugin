//
//  PaymentViewController.swift

 
import UIKit
import SafariServices
import WebKit
import CommonCrypto

protocol IPaymentViewController: class {
    var router: IPaymentRouter? { get set }
    func apiResult(result: paymentResult, response: [String: Any]? , error: Error?)
}

class PaymentViewController: UIViewController {
    var interactor: IPaymentInteractor?
    var router: IPaymentRouter?

    internal var initModel: UWInitializer?
    
    internal var initProto: Initializer? = nil
    
    var activityIndicator =  UIActivityIndicatorView()
    var lblActivityIndicator = UILabel()
    
    var webView: WKWebView = WKWebView()

    var newURL: String = ""

    var splitstring1 : String = ""
    var payid:String = ""
    var tranid:String = ""
    var results:String = ""
    var amount:String = ""
    var cardToken: String = ""
    var respMsg: String = ""
    var responsehash:String = ""
    var responsecode:String = ""
    var cardBrand:String=""
    var maskedPan:String=""
    var data:String = ""
    var requestHash:String = ""
    var merchantKey : String = ""
    var metaData : String = ""
    var paymentType : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do someting...
        self.title = "Payment"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.backgroundColor = .white
        
        guard let model = initModel else {return}
        self.interactor?.postAPI(for: model)

        
        webView = WKWebView()
        webView.configuration.preferences.javaScriptEnabled = true

        webView.navigationDelegate = self
        activityIndicator.frame = CGRect(x: view.frame.width / 2 - 40,
                                         y: view.frame.height / 2,
                                         width: 40,
                                         height: 40)

        activityIndicator.center = view.center
        activityIndicator.color = .red
        webView.frame = view.frame
        self.view.addSubview(webView)
     //   self.view.addSubview(activityIndicator)


        activityIndicator.layer.zPosition = 1
        activityIndicator.startAnimating()
        
        lblActivityIndicator = UILabel(frame: CGRect(x: view.frame.width / 2 - 40,
        y: view.frame.height / 2,
        width: 200,
        height: 150))
        lblActivityIndicator.center = view.center
        lblActivityIndicator.textAlignment = .center
        lblActivityIndicator.textColor = .black
       // lblActivityIndicator.layer.zPosition = 1
        lblActivityIndicator.numberOfLines = 2
        lblActivityIndicator.text = "Please wait \n Transaction is in process ..."
        self.view.addSubview(lblActivityIndicator)
        
        
        webView.configuration.userContentController.addUserScript(self.getZoomDisableScript())
      
       
    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
     
    
}

extension PaymentViewController: IPaymentViewController {
    func apiResult(result: paymentResult , response: [String: Any]?  , error: Error?) {
        
        responsecode = (response?["ResponseCode"] as? String) ?? "nil"
        if responsecode.isEmpty || responsecode == "nil"{
            responsecode = (response?["responseCode"] as? String) ?? "nil"
        }
        print("IN PAYMNET CONTROll " ,response)
        
        if responsecode == "000" {
            print("success")
                           payid = (response?["payid"] as? String) ?? "nil"
                           tranid = (response?["tranid"] as? String) ?? ""
                           responsecode = (response?["ResponseCode"] as? String) ?? "nil"
                           amount = (response?["amount"] as? String) ?? ""
                           cardToken = (response?["cardToken"] as? String) ?? ""
            cardBrand=(response?["cardBrand"] as? String) ?? ""
            maskedPan=(response?["maskedCard"] as? String) ?? ""
            results = (response?["result"] as? String) ?? ""
            metaData=(response?["metaData"] as? String) ?? ""
            paymentType=(response?["paymentType"] as? String) ?? ""
            
            
                           if responsecode.isEmpty || responsecode == "nil"{
                               responsecode = (response?["responseCode"] as? String) ?? "nil"
                           }
                           

                           let message = UMResponceMessage.responseDict[responsecode] ?? ""
                           
            print("MetaData ",metaData)
            print("payment ",paymentType)
                           let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: results ,tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message,metaData: metaData,paymentType: paymentType)
                   
                           initProto?.didPaymentResult(result: .sucess , error: nil , model: model)
                           return
                
            }else {
                print("not sucess")
            
           
            
            // targeturl  == "some value" || targeturl == ""/null
            let targetURL : String = response?["targetUrl"] as? String ?? ""
            if targetURL.count == 0 {
                payid = (response?["payid"] as? String) ?? "nil"
                tranid = (response?["tranid"] as? String) ?? ""
                responsecode = (response?["responseCode"] as? String) ?? "nil"
                amount = (response?["amount"] as? String) ?? ""
                results = (response?["result"] as? String) ?? ""
                cardBrand=(response?["cardBrand"] as? String) ?? ""
                maskedPan=(response?["maskedCard"] as? String) ?? ""
                metaData=(response?["metaData"] as? String) ?? ""
                cardToken = (response?["cardToken"] as? String) ?? ""
                if responsecode.isEmpty || responsecode == "nil"{
                    responsecode = (response?["responseCode"] as? String) ?? "nil"
                }
                
                
                let message = UMResponceMessage.responseDict[responsecode] ?? ""
                print(message)
                
                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result:results,tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message,metaData: metaData,paymentType: paymentType)
                
                initProto?.didPaymentResult(result: .failure(message), error: nil , model: model)
                return
            }else{
                DispatchQueue.main.async {
                    self.lblActivityIndicator.removeFromSuperview()
                    guard  let url = URL(string: fullURL) else {return}
                    self.webView.load(URLRequest(url: url))
                }
            }
               
               
        }
           
    
        
    
    }
 
    // do someting...
}

extension PaymentViewController: WKNavigationDelegate {
    // do someting...
}

extension PaymentViewController {
    // do someting...
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.isLoading {
            return
        }
        estimatedProgress(keyPath: "estimatedProgress")
    }
    
    func estimatedProgress(keyPath :String) {
        
        activityIndicator.startAnimating()
        
        if keyPath == "estimatedProgress" {
            
            print("check-->" ,self.webView.url ?? "")
            let thisnewURL = self.webView.url
            
            self.newURL =  thisnewURL?.absoluteString ?? ""
            
            
            let fullNameArr = self.newURL.components(separatedBy: "&")
            print(fullNameArr)
            
            metaData = fullNameArr.filter({$0.contains("metaData")}).first?.components(separatedBy: "=").last ?? ""

            metaData = fullNameArr.filter({$0.contains("metaData")}).first?.components(separatedBy: "metaData=").last ?? ""
            print("MetaData -->" , metaData)
            
            var decodedString = ""
            if let decodedData = Data(base64Encoded: metaData) {
                metaData = String(data: decodedData, encoding: .utf8)!
            }
            print("MetaData -->" , metaData)
            
            payid = fullNameArr.first?.split(separator: "?").last?.components(separatedBy: "=").last ?? "nill"
            tranid = fullNameArr.filter({$0.contains("TranId")}).first?.components(separatedBy: "=").last ?? ""
            results = fullNameArr.filter({$0.contains("Result")}).first?.components(separatedBy: "=").last ?? ""
            responsecode = fullNameArr.filter({$0.contains("ResponseCode")}).first?.components(separatedBy: "=").last ?? ""
            amount = fullNameArr.filter({$0.contains("amount")}).first?.components(separatedBy: "=").last ?? ""
            cardToken = fullNameArr.filter({$0.contains("CardToken")}).first?.components(separatedBy: "=").last ?? ""
            
            cardBrand =
                fullNameArr.filter({$0.contains("CardBrand")}).first?.components(separatedBy: "=").last ?? ""
            maskedPan =
                fullNameArr.filter({$0.contains("MaskedCard")}).first?.components(separatedBy: "=").last ?? ""
            
            paymentType =
                fullNameArr.filter({$0.contains("PaymentType")}).first?.components(separatedBy: "=").last ?? ""

            
            if payid == "nill" || payid.isEmpty{
                self.payid = tranid
            }
            
            if responsecode.isEmpty {
                responsecode = fullNameArr.filter({$0.contains("Responsecode")}).first?.components(separatedBy: "=").last ?? ""
            }
            
            if paymentType.isEmpty {
                paymentType = fullNameArr.filter({$0.contains("PaymentType")}).first?.components(separatedBy: "=").last ?? ""
            }
//            4236411254582415800
            
            if !responsecode.isEmpty || self.newURL.contains("HTMLPage.html") || self.newURL.contains("gateway"){
                self.activityIndicator.stopAnimating()
                self.lblActivityIndicator.removeFromSuperview()
            }
            
            if (results.caseInsensitiveCompare("Successful") == .orderedSame) || (results.caseInsensitiveCompare("Success") == .orderedSame) {
                
                self.activityIndicator.stopAnimating()
                 self.lblActivityIndicator.removeFromSuperview()
                let message = UMResponceMessage.responseDict[responsecode] ?? ""

                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: results ,tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message,metaData: metaData,paymentType: paymentType)
                
                initProto?.didPaymentResult(result: .sucess , error: nil , model: model)
            }
            else if (results.caseInsensitiveCompare("UnSuccessful") == .orderedSame)
            {
                self.activityIndicator.stopAnimating()
                 self.lblActivityIndicator.removeFromSuperview()
                cardBrand =
                    fullNameArr.filter({$0.contains("CardBrand")}).first?.components(separatedBy: "=").last ?? ""
                maskedPan =
                    fullNameArr.filter({$0.contains("MaskedCard")}).first?.components(separatedBy: "=").last ?? ""
                let message = UMResponceMessage.responseDict[responsecode] ?? ""

                
                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: "Failure",tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message,metaData: metaData,paymentType: paymentType)
                
                initProto?.didPaymentResult(result: .failure(message), error: nil , model: model)
            }
            else if (results.caseInsensitiveCompare("Failure") == .orderedSame)
            {
                print("In Failure")
                let crdbrand =
                    fullNameArr.filter({$0.contains("CardBrand")}).first?.components(separatedBy: "=").last ?? ""
                maskedPan =
                    fullNameArr.filter({$0.contains("maskedCard")}).first?.components(separatedBy: "=").last ?? ""
                self.activityIndicator.stopAnimating()
                 self.lblActivityIndicator.removeFromSuperview()
                
                let message = UMResponceMessage.responseDict[responsecode] ?? ""

                
                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: "Failure",tokenID: cardToken,
                                              cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message ,metaData: metaData,paymentType: paymentType)
                
                initProto?.didPaymentResult(result: .failure(message), error: nil , model: model)
            }
            
            
        } else {
            
            print("Testing")
        }
        
    }
    
   
}



public class PaymentResultData {
    public var paymentID: String
    public var transID: String
    public var responseCode: String
    public var amount: String
    public var result: String
    public var tokenID: String
    public var cardBrand:String
    public var maskedPan:String
    public var respMsg:String
    public var metaData:String
    public var paymentType:String
    
    public init(paymentID: String , transID: String , responseCode: String , amount: String , result: String , tokenID: String,cardBrand:String,maskedPan:String, responseMsg:String,metaData:String,paymentType:String) {
        self.paymentID = paymentID
        self.transID = transID
        self.responseCode = responseCode
        self.amount = amount
        self.result = result
        self.tokenID = tokenID
        self.cardBrand=cardBrand
        self.maskedPan=maskedPan
        self.respMsg=responseMsg
        self.metaData=metaData
        self.paymentType=paymentType
    }
}

